import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/Widget/auth_service.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/home/home_screen.dart';
import 'package:navi_project/home/join/joinin/join_in_screen.dart';
import 'package:validators/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Property
  //파이어베이스 초기화
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('Users');
  //GetX
  final controller = Get.put(ControllerGetX());
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            //Logo 이미지
            Image.asset(
              "assets/images/navi_logo_text.png",
              width: 150,
              height: 150,
            ),

            //로그인 안내문
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "우리는 누구나 범죄자가 될 수 있습니다.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
            ),
            //로그인 입력폼
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        controller: emailTextController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          labelText: "이메일",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "이메일을 입력해주세요";
                          } else if (!isEmail(value)) {
                            return "이메일 형식에 맞지 않습니다.";
                          }
                          return null;
                        }),
                    const SizedBox(height: 24),
                    TextFormField(
                        controller: passwordTextController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          labelText: "비밀번호",
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "비밀번호를 입력해주세요";
                          } else if (value.length > 12) {
                            return "비밀번호의 최대 길이는 12자입니다.";
                          } else if (value.length < 6) {
                            return "비밀번호의 최소 길이는 6자입니다.";
                          }
                          return null;
                        }),
                    const SizedBox(height: 24),

                    //로그인 버튼
                    MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // 폼의 모든 유효성 검사가 통과됐을 때 실행될 코드
                          await signIn(
                            emailTextController.text.trim(),
                            passwordTextController.text.trim(),
                          );

                          // if (userCredential != null) {
                          //   // 로그인 성공
                          //   controller.loginChange();
                          //   Get.offAll(const HomeScreen());
                          // } else {
                          //   return null;
                          //   ShowToast("로그인에 실패하셨습니다.\n잠시 후 다시 시도해 주시기 바랍니다.", 1);
                          // }
                        }
                      },
                      height: 48,
                      minWidth: double.infinity,
                      color: Colors.red,
                      child: const Text(
                        "로그인",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    //Text 버튼
                    TextButton(
                      onPressed: () {
                        Get.to(const JoinInScreen());
                      },
                      child: const Text('아직 회원가입을 안하셨나요? 회원가입'),
                    ),

                    //구글로그인 버튼 구분선
                    const Divider(),
                  ],
                )),
            //구글 로그인 버튼
            GestureDetector(
                onTap: () {
                  print("google tap");

                  // AuthService.instance.signInWithGoogle();
                },
                child: SizedBox(
                  width: 300,
                  child: controller.darkModeSwitch
                      ? Image.asset(
                          "assets/images/btn_google_signin_dark_normal_web.png",
                          width: double.infinity,
                        )
                      : Image.asset(
                          "assets/images/btn_google_signin_light_focus_web.png",
                          width: double.infinity,
                        ),
                )),
            //           ElevatedButton(
            //             onPressed: () {
            //           //     AuthService().signInWithGoogle();
            //           //   },
            //           //   child: const Text('Google Login'),
            // }),
          ]),
        ),
      ),
    );
  }

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      //email검증이 되었는지 확인
      if (userCredential.user!.emailVerified) {
        //emial검증이 확인되었으면 아래 코드를 실행
        //firebase firestore에 접근
        DocumentReference docRef =
            _usersCollection.doc(userCredential.user!.uid);

        // 현재 필드 값을 읽어옵니다.
        DocumentSnapshot docSnapshot = await docRef.get();
        int currentVisitCount =
            (docSnapshot.data() as Map<String, dynamic>)['visitCount'] ?? 0;

        // 필드를 1 증가시킵니다.
        int newVisitCount = currentVisitCount + 1;

        // 업데이트할 데이터를 맵으로 만듭니다.
        Map<String, dynamic> dataToUpdate = {
          'visitCount': newVisitCount,
          'emailVerified': true,
          'admin': false,
          'parters': false,
        };

        // 문서를 업데이트합니다.
        await docRef.update(dataToUpdate);
        //userUid 업데이트
        controller.uidGetX(userCredential.user!.uid);
        //userData 업데이트
        controller.userGetX(userCredential.user!.uid);
        // controller.updateVisitCount(newVisitCount);
        //로그인 상태 변경
        controller.loginChange();
        //email검증 상태 변경
        controller.inputChange();
        //GetX Userdada 반영(GetX에서 실행)
        Get.offAll(() => const HomeScreen());
      } else {
        Get.to(const LoginScreen());
        await _auth.signOut();
        controller.loginChange();
        ShowToast('이메일을 인증해주세요', 3);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Firebase 예외 코드: ${e.code}");
      // FirebaseAuthException 처리
      if (e.code == 'invalid-email') {
        ShowToast('이메일이 일치하지 않습니다.', 1);
      } else if (e.code == 'wrong-password') {
        ShowToast('비밀번호가 일치하지 않습니다.', 1);
      } else {
        ShowToast("로그인에 실패하셨습니다.\n잠시 후 다시 시도해 주시기 바랍니다.", 1);
      }
      return null;
    }
  }
}

//   Future<UserCredential?> signIn(String email, String password) async {
//     try {
//       final userCredential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       print(userCredential);
//       if (userCredential.user!.emailVerified) {
//         controller.inputChange();
//         controller.loginChange();
//         Get.offAll(const HomeScreen());
// DocumentReference docRef = _usersCollection.doc(userCredential.user!.uid);

// // 현재 필드 값을 읽어옵니다.
// DocumentSnapshot docSnapshot = await docRef.get();
// int currentVisitCount = docSnapshot.data()['visitCount'] ?? 0;

// // 필드를 1 증가시킵니다.
// int newVisitCount = currentVisitCount + 1;

// // 업데이트할 데이터를 맵으로 만듭니다.
// Map<String, dynamic> dataToUpdate = {
//   'visitCount': newVisitCount,
// };

// // 문서를 업데이트합니다.
// await docRef.update(dataToUpdate);
//         };
//       } else {
//         Get.to(LoginScreen());
//         await _auth.signOut();
//         controller.loginChange();
//         ShowToast('이메일을 인증해주세요', 3);
//       }

//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       print("Firebase 예외 코드: ${e.code}");
//       // FirebaseAuthException 처리
//       if (e.code == 'invalid-email') {
//         ShowToast('이메일이 일치하지 않습니다.', 1);
//       } else if (e.code == 'wrong-password') {
//         ShowToast('비밀번호가 일치하지 않습니다.', 1);
//       } else {
//         ShowToast("로그인에 실패하셨습니다.\n잠시 후 다시 시도해 주시기 바랍니다.", 1);
//       }
//       return null;
//     }
//   }
// }
