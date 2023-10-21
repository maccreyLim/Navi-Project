import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/home/log/login/log_in_screen.dart'; // GetX 라이브러리를 사용한다고 가정합니다.

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('Users');

  //회원가입구현

  Future<UserCredential?> register(String email, String password,
      String nickname, String mobilePhone) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user!.emailVerified) {
        // 등록이 성공했을 경우 UserCredential을 반환합니다.

        // 이메일 인증이 필요합니다.
        await userCredential.user!.sendEmailVerification();

        // Firestore에 사용자 데이터 저장
        await _usersCollection.doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
          'nickName': nickname,
          'mobilePhone': mobilePhone,
        });

        // 사용자 로그아웃 처리
        await _auth.signOut();

        // 로그인 화면으로 이동
        Get.offAll(LoginScreen());

        // 이메일 인증 메시지 표시
        final userEmailAddress = userCredential.user!.email!;
        ShowToast("등록을 완료하려면 이메일 주소 ($userEmailAddress)를 인증하세요.", 3);
        return userCredential;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        ShowToast("비밀번호는 최소 6자 이상이어야 합니다.", 1);
      } else if (e.code == "email-already-in-use") {
        ShowToast("이미 사용 중인 이메일 주소입니다.", 1);
      } else {
        ShowToast("등록에 실패했습니다. 나중에 다시 시도해 주세요.", 1);
      }
      Get.offAll(LoginScreen());
    }

    // 에러 발생 시 null 반환
    return null;
  }

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // FirebaseAuthException 처리
      if (e.code == 'user-not-found') {
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
