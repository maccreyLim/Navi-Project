import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InterestCalculatorScreen extends StatefulWidget {
  const InterestCalculatorScreen({Key? key}) : super(key: key);

  @override
  _InterestCalculatorScreenState createState() =>
      _InterestCalculatorScreenState();
}

class _InterestCalculatorScreenState extends State<InterestCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController principalController = TextEditingController();
  final f = NumberFormat.currency(locale: 'ko_KR', symbol: '₩');
  int intValue = 0; // 클래스 수준에 변수 정의

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interest Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: principalController,
                decoration: const InputDecoration(
                  labelText: '원금',
                  hintText: '판결문에 인정된 원금을 입력해 주세요',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '숫자를 입력해주세요';
                  }
                  return null;
                },
                onChanged: (value) {
                  // 입력 값이 변경될 때마다 포맷팅하여 다시 설정
                  if (value.isNotEmpty) {
                    // 포맷된 값을 다시 입력 필드에 설정
                    principalController.text = f.format(f.parse(value));
                  }
                },
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    final formattedValue = value.replaceAll(',', ''); // 콤마 제거
                    final double doublevalue =
                        double.parse(formattedValue); // 포맷된 문자열을 double로 파싱
                    intValue = doublevalue.toInt(); // 클래스 수준 변수 업데이트
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // 폼이 유효한 경우 계산 로직을 실행할 수 있음
                    // principalController.text 및 interestRateController.text를 사용하여 계산
                    // ...
                    Text("정수값 : $intValue");
                  }
                },
                child: const Text('Calculate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
