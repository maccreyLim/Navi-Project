import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/Widget/post_firebase.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/post/post_creat_screen.dart';
import 'package:navi_project/post/post_detail_screen.dart';
import 'package:navi_project/model/post_model.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final controller = Get.put(ControllerGetX());
  TextEditingController searchController = TextEditingController();
  String? documentFileID;
  List<PostModel> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("게시판"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 10, 28, 0),
            child: Row(
              children: [
                SizedBox(
                  height: 30,
                  width: MediaQuery.sizeOf(context).width * 0.73,
                  child: TextFormField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      // labelText: '검색어 입력',
                      hintText: '검색할 키워드를 입력하세요',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    performSearch(searchController.text);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('posts')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); //추후수정
                } else if (!snapshot.hasData ||
                    snapshot.data?.docs.isEmpty == true) {
                  return const Text("사용가능한 데이터가 존재하지 않습니다.");
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }

                final posts = snapshot.data!.docs
                    .map((doc) => PostModel.fromDocument(doc))
                    .toList();

                return ListView.builder(
                  itemCount: searchResults.isNotEmpty
                      ? searchResults.length
                      : posts.length,
                  itemBuilder: (context, index) {
                    final post = searchResults.isNotEmpty
                        ? searchResults[index]
                        : posts[index];
                    final imageUrl = post.photoUrls?.isNotEmpty == true
                        ? post.photoUrls![0]
                        : "";

                    return ListTile(
                      leading: imageUrl != ""
                          ? Image.network(
                              imageUrl,
                              height: 60,
                              width: 60,
                            )
                          : const SizedBox(
                              height: 1,
                              width: 1,
                            ),
                      title: Text(
                        post.title,
                        maxLines: 1,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Container(
                        constraints: const BoxConstraints(maxHeight: 48.0),
                        child: Text(
                          post.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      onTap: () {
                        Get.to(() => PostDetailScreen(post: post));
                      },
                      trailing: Visibility(
                        visible: controller.userUid == post.authorUid,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            String? docID =
                                post.documentFileID; // Nullable 문자열로 선언
                            try {
                              // print(docID);
                              await PostFirebaseService().deletePost(docID);
                              // 삭제 작업 성공
                            } catch (e) {
                              ShowToast("삭제 중 오류 발생: $e", 60);
                              // 오류 메시지 출력
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const BoardCreatScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void performSearch(String searchText) {
    if (searchText.isNotEmpty) {
      final endSearchText = searchText + 'z';
      _firestore
          .collection('posts')
          .where('title', isGreaterThanOrEqualTo: searchText)
          .where('title', isLessThan: endSearchText)
          .orderBy('title')
          .get()
          .then((querySnapshot) {
        setState(() {
          searchResults = querySnapshot.docs
              .map((doc) => PostModel.fromDocument(doc))
              .toList();
        });
      }).catchError((error) {
        print('Error searching: $error');
      });
    } else {
      setState(() {
        searchResults.clear();
      });
    }
  }
}
