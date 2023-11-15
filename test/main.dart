import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_firestore.dart';
import 'modle.dart';

void main() async {
  //현재 활성화된 플랫폼에 해당하는 바인딩을 초기화하여  Flutter 앱이 다른 Flutter 기능과 통합되고 플랫폼별 설정이 올바르게 구성되도록 함
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase초기화
  await Firebase.initializeApp(
      //현재 플랫폼에 맞는 Firebase 초기화 옵션을 자동으로 가져와서 사용하는 옵션
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FirebaseFirestore example',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestoreExample firestoreExample =
        FirebaseFirestoreExample();
    return Scaffold(
      appBar: AppBar(
        title: const Text('FirebaseFirStore Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            String result = await firestoreExample
                .createExample(Model(name: 'maccrey', age: 48));
            // 결과를 화면에 표시하는 방법은 앱의 요구 사항에 따라 변경될 수 있음
            Get.snackbar('Result', result); // GetX의 스낵바로 결과를 표시
          },
          child: Text('Create Example'),
        ),
      ),
    );
  }
}
