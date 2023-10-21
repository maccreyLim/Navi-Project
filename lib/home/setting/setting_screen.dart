import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/Widget/admin_mode_switch.dart';
import 'package:navi_project/Widget/dark_mode_switch.dart';
import 'package:navi_project/home/home_screen.dart';
import 'package:navi_project/push_massage/notification.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('환경설정'),
      ),
      body: Column(
        children: [
          DarkSwitch(),
          Divider(
            thickness: 2,
            height: 0,
          ),
          AdminModeSwitch(),
          Divider(
            thickness: 2,
            height: 0,
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () =>
                FlutterLocalNotification.showNotification('셋팅타이틀', '셋팅바디'),
            child: const Text("알림 보내기"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.offAll(HomeScreen());
            },
            child: Text("설정 저장하기"),
          ),
        ],
      ),
    );
  }
}
