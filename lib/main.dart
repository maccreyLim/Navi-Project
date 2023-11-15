import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:navi_project/firebase_options.dart';
import 'package:navi_project/home/home_screen.dart';
import 'package:navi_project/home/log/login/log_in_screen.dart';

import 'GetX/getx.dart';

void main() async {
// Firebase 초기화
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting();
  // Intl.defaultLocale = 'ko_KR'; // 한국어 로컬 설정

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ControllerGetX());
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NAVI',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark(),
        home: controller.isLogin ? HomeScreen() : LoginScreen());
  }
}

class HomeSProfileUpdateScreen {
  const HomeSProfileUpdateScreen();
}
