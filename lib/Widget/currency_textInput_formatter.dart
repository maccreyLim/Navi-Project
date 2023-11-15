import 'package:flutter/services.dart';

class CurrencyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 이전 텍스트와 새로운 텍스트
    final String newText = newValue.text;

    // 소수점의 위치를 찾아봅니다
    int decimalIndex = newText.indexOf('.');

    // 소수점이 없는 경우 또는 소수점이 맨 뒤에 있는 경우 아무것도 변경하지 않습니다.
    if (decimalIndex == -1 || decimalIndex == newText.length - 1) {
      return newValue;
    }

    // 소수점을 포함한 문자열을 새로 만듭니다.
    String formattedValue = newText;

    // 소수점 뒤에 숫자가 더이상 오지 않도록 합니다. 예를 들어 2자리로 제한하려면:
    int maxDecimalDigits = 2; // 소수점 아래 최대 숫자 자릿수
    if (decimalIndex < newText.length - maxDecimalDigits - 1) {
      formattedValue =
          newValue.text.substring(0, decimalIndex + maxDecimalDigits + 1);
    }

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
