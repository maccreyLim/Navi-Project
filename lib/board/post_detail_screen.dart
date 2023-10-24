import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/model/post_coment_model.dart';
import 'package:navi_project/model/post_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:validators/validators.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  // Page 컨트롤러 생성
  PageController pageController = PageController();
  // 현재 슬라이드 인덱스를 저장할 변수
  int bannerIndex = 0;
  final controller = Get.put(ControllerGetX());
  //뎃글 코멘트 작성
  String commentText = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          widget.post.title,
          style: TextStyle(fontWeight: FontWeight.w600),
        ), // 게시물의 제목을 AppBar 제목으로 표시
        actions: [
          controller.userUid == widget.post.authorUid
              ? IconButton(
                  onPressed: () {
                    //파이어베이스 수정기능
                  },
                  icon: Icon(Icons.edit_outlined),
                )
              : Container(),
          controller.userUid == widget.post.authorUid
              ? IconButton(
                  onPressed: () {
                    //파이어베이스 삭제기능
                    _firestore
                        .collection('posts')
                        .doc(widget.post.uid)
                        .delete();
                    Get.back();
                  },
                  icon: Icon(Icons.delete_outline))
              : Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //작성일 표시
                  Text(
                      "작성일 : ${widget.post.createdAt.year}.${widget.post.createdAt.month}.${widget.post.createdAt.day} ${widget.post.createdAt.hour}:${widget.post.createdAt.minute} (${_getWeekday(widget.post.createdAt.weekday)})",
                      style: TextStyle(
                        fontSize: 12,
                      )),
                  //수정일 표시
                  widget.post.updatedAt != ""
                      ? Text(
                          "수정일 : ${widget.post.updatedAt.year}.${widget.post.updatedAt.month}.${widget.post.updatedAt.day} ${widget.post.updatedAt.hour}:${widget.post.updatedAt.minute} (${_getWeekday(widget.post.updatedAt.weekday)})",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        )
                      : Text(""),
                ],
              ),
            ),
          ),
          if (widget.post.photoUrls.isNotEmpty)
            CarouselSlider(
              items: widget.post.photoUrls.map((url) {
                return Container(
                  child: Image.network(
                    url,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                aspectRatio: 4 / 3, // 이미지 종횡비 (선택 사항)
                initialPage: 0, // 초기 페이지 설정
                enableInfiniteScroll: false, // 무한 스크롤 비활성화
                onPageChanged: (index, reason) {
                  setState(() {
                    bannerIndex = index;
                  });
                },
              ),
            ),
          if (widget.post.photoUrls.isEmpty)
            Center(
              child: Text("이미지가 없습니다."),
            ),
          DotsIndicator(
            dotsCount: widget.post.photoUrls.length,
            position: bannerIndex,
            decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(28.0, 9.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          // 현재 슬라이드 인덱스를 표시

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // 테두리 색상 설정
                  width: 1.0, // 테두리 너비 설정
                ),
              ),
              child: SingleChildScrollView(
                child: Text(
                  "${widget.post.content}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          //작성자 표시
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight, // 텍스트를 오른쪽 상단으로 정렬

              child: Text("작성자: ${widget.post.authorNickname}"),
            ),
          ),

          SizedBox(
            height: 10,
          ),
          //코멘트 입력창
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Add a comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {
                  commentText = text;
                });
              },
            ),
          ),
          // Submit comment button
          ElevatedButton(
            onPressed: () {},
            child: Text('Submit Comment'),
          )

          // ... (other code)
        ]),
      ),
    );
  }
}

//Function

String _getWeekday(int weekday) {
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
}
