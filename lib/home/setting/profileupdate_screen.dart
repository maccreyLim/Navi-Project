import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/home/home_screen.dart';
import 'package:validators/validators.dart';
import 'dart:io';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  // Property
  final _formkey = GlobalKey<FormState>();
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('Users');
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final controller = Get.put(ControllerGetX());
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController passwordTextController2 = TextEditingController();
  TextEditingController profileNameTextController = TextEditingController();
  TextEditingController phoneNumTextController = TextEditingController();
  late String _uid; // 사용자 UID를 저장할 변수
  XFile? _pickedFile;

  // emailTextController에 현재 사용자 이메일 설정
  @override
  void initState() {
    super.initState();
    _uid = controller.userUid; // 사용자 UID를 초기화
    emailTextController.text = controller.userData['email'];
    profileNameTextController.text = controller.userData['nickName'];
    phoneNumTextController.text = controller.userData['mobilePhone'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('회원정보수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // 이미지
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.transparent,
                      child: Obx(() {
                        if (controller.userData['photoUrl'] == "") {
                          return Image.asset(
                              'assets/images/navi_logo_text.png');
                        } else {
                          return Image.network(
                            controller.userData['photoUrl'],
                            fit: BoxFit.contain,
                          );
                        }
                      }),
                    ),

                    // 아이콘 버튼
                    Positioned(
                      top: 120, // 이미지에서 위쪽으로 20 픽셀 떨어진 위치
                      right: 0, // 이미지에서 오른쪽으로 20 픽셀 떨어진 위치
                      child: IconButton(
                        onPressed: () async {
                          _getPhotoLibraryImage();
                          // 아이콘 버튼을 누를 때 수행할 작업
                        },
                        icon: const Icon(
                          Icons.camera_alt, // 아이콘을 원하는 아이콘으로 변경
                          color: Colors.black, // 아이콘 색상 설정
                        ),
                        iconSize: 32, // 아이콘 크기 설정
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            // 회원가입 입력창
            SizedBox(
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        enabled: false,
                        controller: emailTextController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
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
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: passwordTextController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "이전비밀번호",
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (value.length > 12) {
                              return "비밀번호의 최대 길이는 12자입니다.";
                            } else if (value.length < 6) {
                              return "비밀번호의 최소 길이는 6자입니다.";
                            }
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
                          border: UnderlineInputBorder(),
                          hintText: "신규비밀번호",
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (value.length > 12) {
                              return "비밀번호의 최대 길이는 12자입니다.";
                            } else if (value.length < 6) {
                              return "비밀번호의 최소 길이는 6자입니다.";
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: profileNameTextController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "닉네임",
                        ),
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
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 55,
                      child: TextFormField(
                        controller: phoneNumTextController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "전화번호",
                        ),
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
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final newPassword = passwordTextController2.text.trim();
                        if (_formkey.currentState!.validate()) {
                          // Firebase DB 업데이트
                          await _usersCollection.doc(_uid).update({
                            'email': emailTextController.text.trim(),
                            'nickName': profileNameTextController.text.trim(),
                            'mobilePhone': phoneNumTextController.text.trim(),
                            'photoUrl': controller.userData['photoUrl'],
                          });
                          ShowToast('프로필이 수정되었습니다.', 1);
                        }
                        // userGetX 업데이트
                        controller.userGetX(_uid);
                        if (newPassword.isNotEmpty) {
                          await changePassword(
                              passwordTextController.text.trim(),
                              passwordTextController2.text.trim());
                        }
                        Get.to(const HomeScreen());
                      },
                      child: const Text('회원정보 수정'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
      Reference ref = storage.ref('profileImage').child('$_uid.jpg');
      TaskSnapshot uploadTask = await ref.putFile(File(_pickedFile!.path));
      controller.userData['photoUrl'] = await uploadTask.ref.getDownloadURL();
    } else {
      if (kDebugMode) {
        ShowToast('이미지를 선택해주세요', 1);
      }
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    // 현재 로그인한 사용자 가져오기
    User? user = _auth.currentUser;

    if (user != null) {
      // 현재 사용자 재인증하기
      AuthCredential credential = EmailAuthProvider.credential(
        email: emailTextController.text.trim(),
        password: currentPassword,
      );

      try {
        await user.reauthenticateWithCredential(credential);

        // 사용자 비밀번호 업데이트
        await user.updatePassword(newPassword);

        ShowToast('비밀번호가 성공적으로 변경되었습니다.', 1);
      } catch (e) {
        ShowToast('비밀번호 변경 중 오류 발생: $e', 1);
      }
    } else {
      ShowToast('사용자가 로그인되지 않았습니다.', 1);
    }
  }
}
