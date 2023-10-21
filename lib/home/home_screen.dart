import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/Widget/home_advertisement.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/board/bored_screen.dart';
import 'package:navi_project/home/log/login/log_in_screen.dart';
import 'package:navi_project/home/setting/profileupdate_screen.dart';

import 'package:navi_project/home/setting/setting_screen.dart';
// import 'package:navi_project/interest_calculator_screen/interest_calculator_screen.dart';
import 'package:navi_project/push_massage/notification.dart';
import 'package:navi_project/schedule/schedulescreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//Property
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
                await _auth.signOut();
                controller.loginChange();
                ShowToast("로그아웃이 되었습니다.", 1);
                setState(() {});
              } else {
                Get.to(LoginScreen());
              }
            },
            icon: controller.isLogin
                ? Icon(Icons.logout)
                : Icon(Icons.login), // 이 위치에 아이콘 설정을 넣어야 합니다.
          ),
          IconButton(
            onPressed: () {
              Get.off(SettingScreen());
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
                if (controller.userData['photoUrl'] == "") {
                  return const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/navi_logo_text.png'),
                  );
                } else {
                  return CircleAvatar(
                    backgroundImage:
                        NetworkImage(controller.userData['photoUrl']),
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
                  return Text("로그인계정 : 없음");
                } else {
                  return Text("로그인계정: ${controller.userData['email']}");
                }
              }),
              onDetailsPressed: () {
                Get.to(() => ProfileUpdateScreen());
              },
              decoration: BoxDecoration(
                color: controller.darkModeSwitch
                    ? Colors.grey[800]
                    : Colors.blue, // 다크 모드에 따라 컬러 변경
                borderRadius: BorderRadius.only(
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
                Get.to(BoardScreen());
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
                Get.to(ScheduleScreen());
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
                // Get.to(InterestCalculatorScreen());
              },
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: const Text('프로필 설정'),
              onTap: () {
                //셋팅 화면으로 이동할 수 있는 로직 추가
                Get.offAll(SettingScreen());
              },
              trailing: const Icon(Icons.navigate_next),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          HomeAdverticement(),
          // Announcement(announceList: announceList),
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
}
