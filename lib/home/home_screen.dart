import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/Widget/announcement_firebase.dart';
import 'package:navi_project/Widget/home_advertisement.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/home/announce_list_model_create_screen.dart';
import 'package:navi_project/home/log/logout/logout_screen.dart';
import 'package:navi_project/model/announcetList_model%20.dart';
import 'package:navi_project/post/post_screen.dart';
import 'package:navi_project/home/log/login/log_in_screen.dart';
import 'package:navi_project/home/setting/profileupdate_screen.dart';

import 'package:navi_project/home/setting/setting_screen.dart';
import 'package:navi_project/interest_calculator_screen/interest_calculator_screen.dart';
import 'package:navi_project/model/post_model.dart';
import 'package:navi_project/push_massage/notification.dart';
import 'package:navi_project/schedule/schedulescreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Query query = FirebaseFirestore.instance.collection('announcement');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final controller = Get.put(ControllerGetX());

  @override
  void initState() {
    FlutterLocalNotification.init();
    Future.delayed(const Duration(seconds: 3),
        FlutterLocalNotification.requestNotificationPermission());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              if (controller.isLogin) {
                Get.to(LogoutScreen());
              } else {
                Get.to(const LoginScreen());
              }
            },
            icon: Icon(
              controller.isLogin ? Icons.logout : Icons.login,
            ),
          ),
          IconButton(
            onPressed: () {
              Get.off(const SettingScreen());
            },
            icon: Icon(Icons.settings),
          ),
        ],
        title: Text(
          "Home Screen",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: Obx(() {
                final photoUrl = controller.userData['photoUrl'];
                return CircleAvatar(
                  backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                      ? NetworkImage(photoUrl)
                      : AssetImage('assets/images/navi_logo_text.png'),
                  maxRadius: 30,
                );
              }),
              accountName: Obx(() {
                return Text(
                  controller.userData['visitCount'] != null
                      ? '현재상태: ${controller.userData['visitCount']}번째 로그인'
                      : '현재상태: 로그아웃',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
              accountEmail: Obx(() {
                return Text(
                  controller.userData['email'] != null
                      ? "로그인계정: ${controller.userData['email']}"
                      : "로그인계정: 없음",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),
              onDetailsPressed: () {
                Get.to(() => const ProfileUpdateScreen());
              },
              decoration: BoxDecoration(
                color:
                    controller.darkModeSwitch ? Colors.grey[800] : Colors.blue,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                '홈',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // Add logic to navigate to the home screen
              },
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.door_sliding_outlined),
              title: Text(
                '게시판',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // Add logic to navigate to the post screen
                Get.to(const PostScreen());
              },
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text(
                'Schedule',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // Add logic to navigate to the schedule screen
                Get.to(const ScheduleScreen());
              },
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text(
                '이자계산기',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // Add logic to navigate to the interest calculator screen
                Get.to(const InterestCalculatorScreen());
              },
              trailing: Icon(Icons.navigate_next),
            ),
            if (controller.isLogin)
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(
                  '프로필 설정',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  // Add logic to navigate to the profile update screen
                  Get.offAll(() => const ProfileUpdateScreen());
                },
                trailing: Icon(Icons.navigate_next),
              ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HomeAdvertisement(),
            SizedBox(height: 30),
            Text(
              " - 공 지 사 항 -",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('댓글 데이터를 가져오는 중 오류가 발생했습니다.');
                }

                final querySnapshot = snapshot.data;
                if (querySnapshot == null || querySnapshot.docs.isEmpty) {
                  return Text('댓글이 없습니다.');
                }

                final announcementList = querySnapshot.docs
                    .map((doc) => AnnouncetListModel.fromMap(
                        doc.data() as Map<String, dynamic>))
                    .toList();

                return Column(
                  children: announcementList
                      .map((comment) => buildCommentItem(comment))
                      .toList(),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(AnnouncetListModelCreateScreen());
                setState(() {});
              },
              child: Text(
                '공지사항 작성',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            MaterialButton(
              onPressed: () =>
                  FlutterLocalNotification.showNotification("타이틀", '바디'),
              child: Text(
                "알림 보내기",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCommentItem(AnnouncetListModel comment) {
    final now = DateTime.now();
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

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${comment.title} ($formattedDate)",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            comment.content,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          Visibility(
            visible: controller.userUid == comment.authorUid,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                // 댓글 삭제 로직을 추가하세요.
                String documentFileID = comment.documentFileID.toString();
                AnnouncementFirebaseService()
                    .deleteAnnouncetList(documentFileID);
              },
            ),
          ),
        ],
      ),
    );
  }
}
