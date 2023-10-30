import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/home/home_screen.dart';
import 'package:navi_project/home/log/login/log_in_screen.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({Key? key}) : super(key: key);

  @override
  _LogoutScreenState createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  //Property
//파이어베이스 초기화
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //GetX
  final controller = Get.put(ControllerGetX());
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // initState에서 애니메이션을 시작합니다.
    startAnimation();
  }

  void startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 20)); // 1초 대기
    setState(() {
      opacity = 1.0; // opacity를 1.0으로 설정하여 이미지가 나타나게 합니다.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              duration: const Duration(seconds: 3), // 애니메이션 지속 시간 설정 (3초)
              opacity: opacity, // 초기에 0.0으로 시작하여 천천히 나타나게 합니다.
              child: Image.asset(
                "assets/images/navi_logo_text.png",
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "우리는 누구나 범죄자가 될 수 있습니다.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 120,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await _auth.signOut();
                        controller.loginChange();
                        Get.offAll(const LoginScreen());
                      },
                      icon: const Icon(
                        Icons.logout,
                        size: 60,
                        color: Colors.redAccent,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '로그 아웃',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        size: 60,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '        계속 놀기',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
