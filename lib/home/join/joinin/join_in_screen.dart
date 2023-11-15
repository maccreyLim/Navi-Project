import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/home/log/login/log_in_screen.dart';
import 'package:navi_project/model/user.dart';
import 'package:validators/validators.dart';

class JoinInScreen extends StatefulWidget {
  const JoinInScreen({super.key});

  @override
  State<JoinInScreen> createState() => _JoinInScreenState();
}

class _JoinInScreenState extends State<JoinInScreen> {
  //Property
  final _formkey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('Users');
  final controller = Get.put(ControllerGetX());
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController passwordTextController2 = TextEditingController();
  TextEditingController profileNameTextController = TextEditingController();
  TextEditingController phoneNumTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    passwordTextController2.dispose();
    profileNameTextController.dispose();
    phoneNumTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: SafeArea(
              child: Column(
            children: [
              //Logo 이미지
              Image.asset(
                "assets/images/navi_logo.png",
                width: 120,
                height: 120,
              ),
              //가입환영메시지
              const Text(
                'NAVI 가입을 환영합니다.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 42,
              ),

              //회원가입 입력창
              SizedBox(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                            controller: emailTextController,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                    // borderRadius:
                                    //     BorderRadius.all(Radius.circular(20)),
                                    ),
                                // labelText: "이메일",
                                hintText: "이메일 주소"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "이메일을 입력해주세요";
                              } else if (!isEmail(value)) {
                                return "이메일 형식에 맞지 않습니다.";
                              }
                              return null;
                            }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: passwordTextController,
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                  // borderRadius:
                                  //     BorderRadius.all(Radius.circular(20)),
                                  ),
                              // labelText: "비밀번호",
                              hintText: "비밀번호"),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "패스워드를 입력해주세요";
                            } else if (value.length > 12) {
                              return "패스워드의 최대 길이는 12자입니다.";
                            } else if (value.length < 6) {
                              return "패스워드의 최소 길이는 6자입니다.";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                            controller: passwordTextController2,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                    // borderRadius:
                                    //     BorderRadius.all(Radius.circular(20)),
                                    ),
                                // labelText: "비밀번호확인",
                                hintText: "비밀번호확인"),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
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
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          height: 50,
                          child: TextFormField(
                            controller: profileNameTextController,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                    // borderRadius:
                                    //     BorderRadius.all(Radius.circular(20)),
                                    ),
                                // labelText: "닉네임",
                                hintText: "닉네임"),
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "닉네임을 입력해주세요.";
                              } else if (value.length > 12) {
                                return "닉네임의 최대 길이는 12자입니다.";
                              } else if (value.length < 3) {
                                return "닉네임의 최소 길이는 3자입니다.";
                              }
                              return null;
                            },
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 55,
                        child: TextFormField(
                          controller: phoneNumTextController,
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                  // borderRadius:
                                  //     BorderRadius.all(Radius.circular(20)),
                                  ),
                              // labelText: "모바일폰 번호",
                              hintText: "전화번호"),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "모바일폰번호를 입력하세요";
                            } else if (value.length < 11) {
                              return "모바일폰 번호를 확인해주세요.";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              //회원가입 버튼
              MaterialButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    if (passwordTextController.text ==
                        passwordTextController2.text) {
                      register(
                        emailTextController.text.trim(),
                        passwordTextController.text.trim(),
                      );
                    } else {
                      ShowToast('비밀번호가 일치하지 않습니다.', 1);
                    }
                  }
                },
                height: 48,
                minWidth: double.infinity,
                color: Colors.red,
                child: const Text(
                  "회원가입",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  //Function
  Future<UserCredential?> register(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user!.email != null) {
        // Firestore에 사용자 데이터 저장
        await _usersCollection.doc(userCredential.user!.uid).set(
              UserModel(
                uid: userCredential.user!.uid,
                email: emailTextController.text.trim(),
                nickName: profileNameTextController.text.trim(),
                mobilePhone: phoneNumTextController.text.trim(),
                visitCount: 0,
                emailVerified: false,
                admin: false,
                partners: false,
                photoUrl: "",
              ).toJson(),
            );

        // 이메일 인증을 보냄.
        await userCredential.user!.sendEmailVerification();
        Get.to(const LoginScreen());
        final userEmailAddress = userCredential.user!.email!;
        ShowToast("등록을 완료하려면 이메일 주소 ($userEmailAddress)를 인증하세요.", 3);
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        ShowToast("비밀번호는 최소 6자 이상이어야 합니다.", 1);
      } else if (e.code == "email-already-in-use") {
        ShowToast("이미 사용 중인 이메일 주소입니다.", 1);
      } else {
        ShowToast("등록에 실패했습니다. 나중에 다시 시도해 주세요.", 1);
      }
      Get.offAll(const LoginScreen());
    }
    return null;
  }
}
