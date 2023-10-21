import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:navi_project/firebase_options.dart';
import 'package:navi_project/home/home_screen.dart';
import 'package:navi_project/schedule/schedulescreen.dart';
import 'package:intl/intl.dart';

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
    return GetMaterialApp(
      title: 'NAVI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      home: HomeScreen(),
      // const ScheduleScreen(),
      // const ProfileUpdateScreen(),
    );
  }
}

class HomeSProfileUpdateScreen {
  const HomeSProfileUpdateScreen();
}
