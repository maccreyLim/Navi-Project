import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/release_calculator_screen/release_calculator_firebase.dart';
import 'package:navi_project/release_calculator_screen/release_model.dart';

class ReleaseCalculatorCreate extends StatefulWidget {
  const ReleaseCalculatorCreate({Key? key}) : super(key: key);

  @override
  _ReleaseCalculatorCreateState createState() =>
      _ReleaseCalculatorCreateState();
}

class _ReleaseCalculatorCreateState extends State<ReleaseCalculatorCreate> {
  //Property
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now(); // 초기 선택 날짜
  var years = 0;
  var months = 6;
  var name = '이름을 입력해 주세요';

  final yearformatter = DateFormat('yyyy');
  final monthformatter = DateFormat('MM');
  final dayformatter = DateFormat('dd');
  DateTime releaseDate = DateTime(2023, 11, 14); // 초기 출소일

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('출소일 입력'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, // Assign the form key
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '성 명',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 64),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width * 0.5),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이름을 입력해 주세요';
                          }
                          return null; // 유효한 경우에는 null을 반환
                        },
                        decoration: InputDecoration(
                          hintText: name,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '입소일',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 18),
                    Text(
                      '${yearformatter.format(selectedDate)} 년 ${monthformatter.format(selectedDate)} 월 ${dayformatter.format(selectedDate)} 일',
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      icon: Icon(Icons.date_range_outlined),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '형량 설정',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 26),
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            years = int.parse(value);
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '필수';
                          }
                          return null; // 유효한 경우에는 null을 반환
                        },
                        decoration: InputDecoration(
                          hintText: '년',
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            months = int.parse(value);
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '필수';
                          }
                          return null; // 유효한 경우에는 null을 반환
                        },
                        decoration: InputDecoration(
                          hintText: '개월',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.53,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Trigger form validation
                      if (_formKey.currentState?.validate() ?? false) {
                        final release = ReleaseFirestore();
                        String result = await release.createRelease(
                          ReleaseModel(
                            name: name,
                            inputDate: selectedDate,
                            years: years,
                            months: months,
                          ),
                        );
                        ShowToast('저장되었습니다.', 1);
                        Get.back();
                        print(result);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      '저장하기',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
