import 'package:validators/validators.dart';

class InputValidators {
  // 닉네임 검증
  static String? validateNickName(String? value) {
    if (value == null || value.isEmpty) {
      return "닉네임을 입력해주세요.";
    } else if (!isAlphanumeric(value)) {
      return "닉네임에는 한글이나 특수 문자가 들어갈 수 없습니다.";
    } else if (value.length > 12) {
      return "닉네임의 최대 길이는 12자입니다.";
    } else if (value.length < 3) {
      return "닉네임의 최소 길이는 3자입니다.";
    }
    return null;
  }

  // 이메일 검증
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "이메일을 입력해주세요";
    } else if (!isEmail(value)) {
      return "이메일 형식에 맞지 않습니다.";
    }
    return null;
  }

  // 패스워드 검증
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "패스워드를 입력해주세요";
    } else if (value.length > 12) {
      return "패스워드의 최대 길이는 12자입니다.";
    } else if (value.length < 6) {
      return "패스워드의 최소 길이는 6자입니다.";
    }
    return null;
  }

  // 모바일폰 검증
  static String? validatePhoneNum(String? value) {
    if (value == null || value.isEmpty) {
      return "모바일폰번호를 입력하세요";
    } else if (value.length < 11) {
      return "모바일폰 번호를 확인해주세요.";
    }
    return null;
  }
}
