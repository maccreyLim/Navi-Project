import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/Widget/admin_mode_switch.dart';
import 'package:navi_project/Widget/dark_mode_switch.dart';
import 'package:navi_project/home/announce_list_model_create_screen.dart';
import 'package:navi_project/home/home_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  //Property
  final controller = Get.put(ControllerGetX());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('환경설정'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                Text('Dark Mode'),
                DarkSwitch(),
              ],
            ),
          ),
          const Divider(
            thickness: 2,
            height: 0,
          ),

          const AdminModeSwitch(),
          const Divider(
            thickness: 2,
            height: 0,
          ),
          const SizedBox(
            height: 20,
          ),
          //공지사항 작성을 위해 필요한 버튼 ( 회원데이타에서 관리자인경우와 관리자 모드를 켰을때만 보이게 구현)
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() {
                  if (controller.userData['admin'] == true &&
                      controller.adminModeSwich.value == true) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 1,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(const AnnouncetListModelCreateScreen());
                        },
                        child: const Text('공지사항 작성'),
                      ),
                    );
                  } else {
                    // You can also return an empty container or null if the button shouldn't be visible
                    return Container();
                  }
                }),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Get.offAll(const HomeScreen());
                      });
                    },
                    child: const Text("설정 저장하기"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
