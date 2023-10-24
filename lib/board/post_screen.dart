import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/board/post_detail_screen.dart';
import 'package:navi_project/model/post_model.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final controller = Get.put(ControllerGetX());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("게시판"), // AppBar에 "게시판" 텍스트 추가
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('posts')
                .orderBy('createdAt',
                    descending: true) // 'createdAt' 필드를 사용하여 오름차순으로 정렬
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // 연결 대기 중인 동안 로딩 표시
              } else if (!snapshot.hasData ||
                  snapshot.data?.docs.isEmpty == true) {
                return const Text("사용가능한 데이가 존재하지 않습니다."); // 데이터가 없을 경우 메시지 표시
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}"); // 오류 발생시 메시지 표시
              }

              // 데이터를 처리할 코드 (데이터가 로드된 경우)
              final posts = snapshot.data!.docs
                  .map((doc) => PostModel.fromDocument(doc))
                  .toList();

              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  final imageUrl = post.photoUrls.isNotEmpty
                      ? post.photoUrls[0]
                      : ''; // 첫 번째 사진 URL
                  return ListTile(
                    leading: imageUrl.isNotEmpty
                        ? Image.network(imageUrl) // 첫 번째 사진을 표시
                        : Container(), // 사진이 없을 경우 빈 컨테이너
                    title: Text(post.title),
                    subtitle: Container(
                      constraints: BoxConstraints(maxHeight: 48.0), // 최대 높이 제한
                      child: Text(
                        post.content,
                        maxLines: 2, // 최대 두 줄까지 표시
                        overflow: TextOverflow.ellipsis, // 넘치는 내용은 '...'으로 표시
                      ),
                    ),
                    onTap: () {
                      Get.to(() => PostDetailScreen(post: post));
                    },
                    trailing: Visibility(
                      visible: controller.userUid ==
                          post.authorUid, // Only show if the condition is true
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _firestore.collection('posts').doc(post.uid).delete();
                        },
                      ),
                    ),
                  );
                },
              );
            }));
  }
}
