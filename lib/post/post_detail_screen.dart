import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/Widget/post_coment_firbase.dart';
import 'package:navi_project/Widget/post_firebase.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/model/post_comment_model.dart';
import 'package:navi_project/model/post_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:navi_project/post/post_update_scrren.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel post;

  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  PageController pageController = PageController();
  int bannerIndex = 0;
  final controller = Get.put(ControllerGetX());
  final TextEditingController _textController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          widget.post.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          controller.userUid == widget.post.authorUid
              ? IconButton(
                  onPressed: () {
                    // 파이어베이스 수정기능
                    // Get.to(PostUpdateScreen(post: widget.post));
                  },
                  icon: const Icon(Icons.edit_outlined),
                )
              : Container(),
          controller.userUid == widget.post.authorUid
              ? IconButton(
                  onPressed: () async {
                    String? docID =
                        widget.post.documentFileID; // Nullable 문자열로 선언
                    try {
                      // print(docID);
                      await PostFirebaseService().deletePost(docID);
                      // 삭제 작업 성공
                    } catch (e) {
                      ShowToast("삭제 중 오류 발생: $e", 60);
                      // 오류 메시지 출력
                    }
                    // 파이어베이스 삭제기능
                    // _firestore
                    //     .collection('posts')
                    //     .doc(widget.post.documentFileID)
                    //     .delete();
                    Get.back();
                  },
                  icon: const Icon(Icons.delete_outline),
                )
              : Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "작성일 : ${widget.post.createdAt?.year}.${widget.post.createdAt?.month}.${widget.post.createdAt?.day} ${widget.post.createdAt?.hour}:${widget.post.createdAt?.minute} (${_getWeekday(widget.post.createdAt?.weekday)})",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    widget.post.updatedAt != null
                        ? Text(
                            "수정일 : ${widget.post.updatedAt?.year}.${widget.post.updatedAt?.month}.${widget.post.updatedAt?.day} ${widget.post.updatedAt?.hour}:${widget.post.updatedAt?.minute} (${_getWeekday(widget.post.updatedAt?.weekday)})",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          )
                        : const Text("")
                  ],
                ),
              ),
            ),
            //이미지 표시
            widget.post.photoUrls?.isEmpty ?? true
                ? Container(
                    height: 10,
                  )
                : Container(
                    height: MediaQuery.sizeOf(context).height * 0.24,
                    width: MediaQuery.sizeOf(context).width * 1,
                    child: imageSlider()),
            // SizedBox(height: 20),
            //본문표시
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 0.3,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    widget.post.content.replaceAll('\n', '\n'),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Text("작성자: ${widget.post.authorNickname}"),
              ),
            ),
            Container(
              height: 160,
              child: StreamBuilder<List<PostCommentModel>>(
                stream: PostComentFirebaseService()
                    .readComments(widget.post.documentFileID.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('댓글이 없습니다.');
                  } else if (snapshot.hasError) {
                    return const Text('댓글 데이터를 가져오는 중 오류가 발생했습니다.');
                  }

                  final comments = snapshot.data!;
                  return buildCommentListView(comments);
                },
              ),
            ),

            //코멘트입력창
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // height: 55,
                width: MediaQuery.sizeOf(context).width / 0.9,
                child: TextField(
                  style: TextStyle(fontSize: 15),
                  maxLines: null,
                  controller: _textController,
                  decoration: InputDecoration(
                    // hintText: 'Add a comment',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        // IconButton이 클릭되었을 때 수행할 작업을 여기에 추가합니다.
                        // 예를 들어, 댓글을 저장하거나 다른 동작을 수행할 수 있습니다.
                        PostCommentModel comment = PostCommentModel(
                          authorUid: controller.userUid,
                          authorNickname: controller.userData['nickName'],
                          createdAt: DateTime.now(),
                          content: _textController.text,
                          isLiked: false,
                          likeCount: 0,
                          photoUrl: controller.userData['photoUrl'],
                        );
                        PostComentFirebaseService().createComment(
                          comment,
                          widget.post.documentFileID.toString(),
                        );
                        setState(() {
                          _textController.clear();
                        });
                        ShowToast('코멘트 저장 완료', 1);
                      },
                      icon: Icon(
                        Icons.save,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWeekday(int? weekday) {
    if (weekday != null) {
      switch (weekday) {
        case 1:
          return "월요일";
        case 2:
          return "화요일";
        case 3:
          return "수요일";
        case 4:
          return "목요일";
        case 5:
          return "금요일";
        case 6:
          return "토요일";
        case 7:
          return "일요일";
        default:
          return "";
      }
    } else {
      return "";
    }
  }

  Widget imageSlider() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.post.photoUrls?.length ?? 0,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final imageUrl = widget.post.photoUrls?[index] ?? '';
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            );
          },
          options: CarouselOptions(
            height: 160,
            viewportFraction: 1.0, // 이미지가 화면 전체를 채우도록 설정
            initialPage: 0,
            enableInfiniteScroll: true,
            onPageChanged: (index, reason) {
              setState(() {
                bannerIndex = index;
              });
            },
          ),
        ),
        DotsIndicator(
          dotsCount: widget.post.photoUrls?.length ?? 0,
          position: bannerIndex,
          decorator: DotsDecorator(
            size: const Size.square(9.0),
            activeSize: const Size(28.0, 9.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCommentListView(List<PostCommentModel> comments) {
    final now = DateTime.now();

    return SizedBox(
      height: 180,
      // MediaQuery.sizeOf(context).height * 0.5,
      child: ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          final DateTime created = comment.createdAt;
          final Duration difference = now.difference(created);

          String formattedDate;

          if (difference.inHours > 0) {
            formattedDate = '${difference.inHours}시간 전';
          } else if (difference.inMinutes > 0) {
            formattedDate = '${difference.inMinutes}분 전';
          } else {
            formattedDate = '방금 전';
          }

          return ListTile(
            leading: comment.photoUrl != ""
                ? Image.network(comment.photoUrl)
                : const SizedBox(width: 0, height: 0), // 이미지가 없는 경우 빈 상자
            title: Text(
              "${comment.authorNickname} ($formattedDate)",
              style: TextStyle(fontSize: 10),
            ),
            subtitle: Text(
              comment.content,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            trailing: Visibility(
              visible: controller.userUid == comment.authorUid,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  // 댓글 삭제 로직을 추가하세요.
                  String _postId = widget.post.documentFileID.toString();
                  String _commentId = comment.documentFileID.toString();
                  PostComentFirebaseService()
                      .deleteComment(_postId, _commentId);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
