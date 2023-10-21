// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class InterestCalculatorScreen extends StatefulWidget {
//   const InterestCalculatorScreen({super.key});

//   @override
//   State<InterestCalculatorScreen> createState() =>
//       _InterestCalculatorScreenState();
// }

// class _InterestCalculatorScreenState extends State<InterestCalculatorScreen> {
// // 원금, 1차 이자율, 2차 이자율, 계산된 이자, 합계를 저장할 변수
//   late double principal; //원금
//   late double interestRate1; //1차 이자율
//   late double interestRate2; //2차 이자율
//   double interestNun1 = 0; //1차이자금
//   double interestNun2 = 0; //2차이자금
//   double total = 0; //합계

//   late DateTime startDateNun1; //1차개시날짜
//   late DateTime startDateNun2; //2차개시날짜
//   late DateTime endDateNun2; //만료날짜

//       final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     if (picked != null) {
//       setState(() {
//         if (stage == 1) {
//           startDateNun1 = picked;
//         } else {
//           // 다른 스테이지의 날짜 설정도 업데이트할 수 있습니다.
//         }
//       });
//     }
//   }

//   void _selectEndDate(BuildContext context, int stage) async {
//     late DateTime? selectedDate;
//      DateFormat('yyyy-MM-dd').format(selectedDate);
//     if (stage == 1) {
//       selectedDate = endDateNun1 ?? DateTime.now();
//     } else {
//       // 다른 스테이지의 날짜 선택 기능도 추가할 수 있습니다.
//     }

//     final DateTime picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     if (picked != null) {
//       setState(() {
//         if (stage == 1) {
//           endDateNun1 = picked;
//         } else {
//           // 다른 스테이지의 날짜 설정도 업데이트할 수 있습니다.
//         }
//       });
//     }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: const Text('Interest Calculator'),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.calculate,
//             ),
//             iconSize: 25,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               // 원금 입력
//               decoration: InputDecoration(labelText: '원금'),
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 principal = double.parse(value);
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               // 1차 이자율 입력
//               decoration: InputDecoration(labelText: '1차 이자율'),
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 interestRate1 = double.parse(value);
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               // 2차 이자율 입력
//               decoration: InputDecoration(labelText: '2차 이자율'),
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 interestRate2 = double.parse(value);
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               // 개시 날짜 입력
//               decoration: InputDecoration(labelText: '1차 개시 날짜'),
//               keyboardType: TextInputType.datetime,
//               readOnly: true, // 텍스트 필드를 편집 불가능하게 만듭니다.
//               onTap: () {
//                 _selectStartDate(context, 1); // 1차 개시 날짜 선택 다이얼로그를 엽니다.
//               },
//               controller: TextEditingController(
//                 text: startDateNun1 == null
//                     ? ''
//                     : DateFormat('yyyy-MM-dd').format(startDateNun1),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               // 만료 날짜 입력
//               decoration: InputDecoration(labelText: '1차 만료 날짜'),
//               keyboardType: TextInputType.datetime,
//               readOnly: true, // 텍스트 필드를 편집 불가능하게 만듭니다.
//               onTap: () {
//                 _selectEndDate(context, 1); // 1차 만료 날짜 선택 다이얼로그를 엽니다.
//               },
//               controller: TextEditingController(
//                 text: endDateNun1 == null
//                     ? ''
//                     : DateFormat('yyyy-MM-dd').format(endDateNun1),
//               ),
//             ),
//           ),

//           Text('1차이자: $interestNun1'), // 계산된 이자 표시
//           Text('2차이자: $interestNun2'), // 계산된 이자 표시
//           Text('합계: $total'), // 합계 표시
//         ],
//       ),
//     );
//   }

//   void calculateInterest() {
//     // TODO: 이자 계산 로직 구현
//     // startDate와 endDate 간의 기간을 계산하세요.
//     // 원금과 1차 이자율로 1차 이자를 계산하세요.
//     // 2차 이자율을 적용하여 2차 이자를 계산하세요.
//     // 계산된 이자와 원금을 합하여 total을 설정하세요.
//     // 이자와 합계를 setState()를 사용하여 화면에 업데이트하세요.
//   }
//   void _selectStartDate(BuildContext context, int stage) async {
//     late DateTime? selectedDate;
//     DateFormat('yyyy-MM-dd').format(selectedDate);

//     if (stage == 1) {
//       selectedDate = startDateNun1 ?? DateTime.now();
//     } else {
//       // 다른 스테이지의 날짜 선택 기능도 추가할 수 있습니다.
//     }
//   }
// }
