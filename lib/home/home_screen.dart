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
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//Property
  final Query query = FirebaseFirestore.instance.collection('announcement');
//파이어베이스 초기화
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //GetX
  final controller = Get.put(ControllerGetX());

  @override
  void initState() {
    // 초기화
    FlutterLocalNotification.init();

    // 3초 후 권한 요청
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
              // 로그인 및 로그아웃 구현
              if (controller.isLogin) {
                Get.to(LogoutScreen());
              } else {
                Get.to(const LoginScreen());
              }
            },
            icon: controller.isLogin
                ? const Icon(Icons.logout)
                : const Icon(Icons.login), // 이 위치에 아이콘 설정을 넣어야 합니다.
          ),
          IconButton(
            onPressed: () {
              Get.off(const SettingScreen());
            },
            icon: const Icon(Icons.settings),
          ),
        ],
        title: const Text("Home Screen"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: Obx(() {
                final photoUrl = controller.userData['photoUrl'];
                if (photoUrl == null || photoUrl.isEmpty) {
                  return const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/navi_logo_text.png'),
                  );
                } else {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(photoUrl),
                    maxRadius: 30,
                  );
                }
              }),
              accountName: Obx(() {
                if (controller.userData['visitCount'] == null) {
                  return const Text('현재상태 : 로그아웃');
                } else {
                  return Text(
                      '현재상태: ${controller.userData['visitCount']}번째 로그인');
                }
              }),
              accountEmail: Obx(() {
                if (controller.userData['email'] == null) {
                  return const Text("로그인계정 : 없음");
                } else {
                  return Text("로그인계정: ${controller.userData['email']}");
                }
              }),
              onDetailsPressed: () {
                Get.to(() => const ProfileUpdateScreen());
              },
              decoration: BoxDecoration(
                color: controller.darkModeSwitch
                    ? Colors.grey[800]
                    : Colors.blue, // 다크 모드에 따라 컬러 변경
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: const Text('홈'),
              onTap: () {
                // 홈 화면으로 이동할 수 있는 로직 추가
              },
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: const Icon(Icons.door_sliding_outlined),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: const Text('게시판'),
              onTap: () {
                // 게시판으로 이동할 수 있는 로직 추가
                Get.to(const PostScreen());
              },
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: const Text('Schedule'),
              onTap: () {
                // 스케줄 화면으로 이동할 수 있는 로직 추가
                Get.to(const ScheduleScreen());
              },
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: const Text('이자계산기'),
              onTap: () {
                // 이자계산기 화면으로 이동할 수 있는 로직 추가
                Get.to(const InterestCalculatorScreen());
              },
              trailing: const Icon(Icons.navigate_next),
            ),
            if (controller.isLogin)
              ListTile(
                leading: const Icon(Icons.settings),
                iconColor: Colors.purple,
                focusColor: Colors.purple,
                title: const Text('프로필 설정'),
                onTap: () {
                  // 프로필 업데이트 화면으로 이동하는 로직 추가
                  Get.offAll(() => const ProfileUpdateScreen());
                },
                trailing: const Icon(Icons.navigate_next),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          const HomeAdverticement(),
          SizedBox(
            height: 30,
          ),
          Text(
            " - 공 지 사 항 -",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              child: StreamBuilder<QuerySnapshot>(
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

              return SingleChildScrollView(
                  child: buildCommentListView(announcementList));
            },
          )),
          ElevatedButton(
            onPressed: () {
              Get.to(AnnouncetListModelCreateScreen());
              setState(() {});
            },
            child: const Text('공지사항 작성'),
          ),
          MaterialButton(
            onPressed: () =>
                FlutterLocalNotification.showNotification("타이틀", '바디'),
            child: const Text("알림 보내기"),
          ),
        ],
      ),
    );
    //DarkMode 스위치
  }

  Widget buildCommentListView(List<AnnouncetListModel> announcementList) {
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        child: SizedBox(
          height: 210,
          child: ListView.builder(
            itemCount: announcementList.length,
            itemBuilder: (context, index) {
              final comment = announcementList[index];
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
                title: Text("${comment.title} ($formattedDate)"),
                subtitle: Text(comment.content),
                trailing: Visibility(
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
              );
            },
          ),
        ),
      ),
    );
  }
}
