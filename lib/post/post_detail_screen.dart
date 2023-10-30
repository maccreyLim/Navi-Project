import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/Widget/post_coment_firbase.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/model/post_comment_model.dart';
import 'package:navi_project/model/post_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
                  },
                  icon: const Icon(Icons.edit_outlined),
                )
              : Container(),
          controller.userUid == widget.post.authorUid
              ? IconButton(
                  onPressed: () {
                    // 파이어베이스 삭제기능
                    _firestore
                        .collection('posts')
                        .doc(widget.post.documentFileID)
                        .delete();
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
                    widget.post.updatedAt == null
                        ? Text(
                            "수정일 : ${widget.post.updatedAt?.year}.${widget.post.updatedAt?.month}.${widget.post.updatedAt?.day} ${widget.post.updatedAt?.hour}:${widget.post.updatedAt?.minute} (${_getWeekday(widget.post.updatedAt?.weekday)})",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          )
                        : const Text(""),
                  ],
                ),
              ),
            ),
            widget.post.photoUrls?.isEmpty ?? true
                ? Container(
                    height: 10,
                  )
                : imageSlider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
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
              child: StreamBuilder<List<PostCommentModel>>(
                stream: PostComentFirebaseService()
                    .readComments(widget.post.documentFileID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('댓글이 없습니다.');
                  } else if (snapshot.hasError) {
                    return Text('댓글 데이터를 가져오는 중 오류가 발생했습니다.');
                  }

                  final comments = snapshot.data!;
                  return SingleChildScrollView(
                      child: buildCommentListView(comments));
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: Row(
                children: [
                  SizedBox(
                    // height: 35,
                    width: MediaQuery.sizeOf(context).width / 1.2,
                    child: TextFormField(
                      maxLines: null,
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: 'Add a comment',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      PostCommentModel comment = PostCommentModel(
                        authorUid: controller.userUid,
                        authorNickname: controller.userData['nickName'],
                        createdAt: DateTime.now(),
                        content: _textController.text,
                        isLiked: false,
                        likeCount: 0,
                      );
                      PostComentFirebaseService().createComment(
                        comment,
                        widget.post.documentFileID,
                      );
                      setState(() {
                        _textController.clear();
                      });
                      ShowToast('코멘트 저장 완료', 1);
                    },
                    icon: const Icon(
                      Icons.save,
                      size: 32,
                    ),
                  ),
                ],
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
        CarouselSlider(
          items: widget.post.photoUrls?.map((url) {
            return Container(
              child: Image.network(
                url,
                height: 160,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            );
          }).toList(),
          options: CarouselOptions(
            aspectRatio: 4 / 3,
            initialPage: 0,
            enableInfiniteScroll: false,
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
      height: 300,
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
            title: Text("${comment.authorNickname} ($formattedDate)"),
            subtitle: Text(comment.content),
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
