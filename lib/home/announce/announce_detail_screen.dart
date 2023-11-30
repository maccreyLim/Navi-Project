import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/Widget/announcement_firebase.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/model/announcetList_model%20.dart';
import 'package:validators/validators.dart';

class AnnounceDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Property
// GetX 컨트롤러 인스턴스
    final controller = Get.put(ControllerGetX());
    final AnnouncetListModel comment = Get.arguments as AnnouncetListModel;

    // Format the DateTime object
    String formattedDate =
        DateFormat('yyyy년 MM월 dd일 HH:mm').format(comment.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: Text('Announcement Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  comment.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.38,
                ),
                Container(
                  child: Text(
                    '작성일: $formattedDate',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            SizedBox(height: 16),
            SingleChildScrollView(
              child: Container(
                color: const Color.fromARGB(255, 236, 236, 235),
                height: MediaQuery.of(context).size.height * 0.55,
                width: MediaQuery.of(context).size.width * 1,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    comment.content,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Visibility(
                  visible: comment.authorUid == controller.userUid,
                  child: ElevatedButton(
                    onPressed: () {
// 댓글 삭제 로직을 추가하세요.
                      String documentFileID = comment.documentFileID.toString();
//파이어베이스에서 공지사항 삭제 구현
                      AnnouncementFirebaseService()
                          .deleteAnnouncetList(documentFileID);
                      ShowToast("공지사항이 삭제되었습니다.", 1);
                      Get.back();
                    },
                    child: const Text('삭제'),
                  ),
                ),
                if (comment.authorUid == controller.userUid)
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('확인'),
                  )
                else
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.89,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('확인'),
                    ),
                  )
              ],
            ),
            // Add more Text widgets or other widgets for additional details
          ],
        ),
      ),
    );
  }
}
