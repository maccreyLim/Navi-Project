import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/release_calculator_screen/release_calculator_create.dart';
import 'package:navi_project/release_calculator_screen/release_calculator_edit.dart';
import 'package:navi_project/release_calculator_screen/release_calculator_firebase.dart';
import 'package:navi_project/release_calculator_screen/release_model.dart';

class ReleaseCalculatorScreen extends StatefulWidget {
  const ReleaseCalculatorScreen({Key? key}) : super(key: key);

  @override
  _ReleaseCalculatorScreenState createState() =>
      _ReleaseCalculatorScreenState();
}

class _ReleaseCalculatorScreenState extends State<ReleaseCalculatorScreen> {
  final controller = Get.put(ControllerGetX());
  final ReleaseFirestore releaseFirestore = ReleaseFirestore();

  // 출소일 계산 함수
  DateTime calculateReleaseDate(DateTime inputDate, int years, int months) {
    // 1월의 날 수를 결정하기 위해 윤년 여부 확인
    final int daysInJanuary = isLeapYear(inputDate.year) ? 31 : 30;

    // 년과 개월을 Duration으로 변환하여 더하기
    final Duration duration = Duration(days: years * 365 + months * 30);

    // inputDate에 duration을 더하여 출소일 계산
    DateTime releaseDate = inputDate.add(duration);

    // 출소일이 1월이면서 윤년 여부에 따라 조정
    if (releaseDate.month == 1) {
      releaseDate = releaseDate.add(Duration(days: daysInJanuary - 1));
    }

    return releaseDate;
  }

  // 윤년 여부 확인 함수
  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  // Timestamp를 DateTime으로 변환하는 함수
  DateTime convertTimestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('출소일 계산기'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const ReleaseCalculatorCreate());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<List<ReleaseModel>>(
        stream: releaseFirestore.getReleasesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return const Text('오류가 발생했습니다. 다시 시도하세요.');
          } else {
            List<ReleaseModel>? releases = snapshot.data;

            if (releases == null || releases.isEmpty) {
              return const Center(
                child: Text('출소 정보가 없습니다.'),
              );
            }

            Map<String, double> percentageMap = {};
            DateTime currentDate = DateTime.now();

            return SingleChildScrollView(
              child: Column(
                children: releases.map((release) {
                  DateTime inputDate = release.inputDate;
                  DateTime releaseDate;

                  if (release.years != 0 || release.months != 0) {
                    final int daysInJanuary =
                        isLeapYear(inputDate.year) ? 31 : 30;
                    final Duration duration = Duration(
                        days: release.years * 365 + release.months * 30);
                    releaseDate = inputDate.add(duration);

                    if (releaseDate.month == 1) {
                      releaseDate =
                          releaseDate.add(Duration(days: daysInJanuary - 1));
                    }
                  } else {
                    releaseDate = inputDate;
                  }

                  double progressPercentage = 0.0;

                  if (release.years != 0 || release.months != 0) {
                    progressPercentage =
                        ((currentDate.difference(inputDate).inDays) /
                                (releaseDate.difference(inputDate).inDays)) *
                            100;

                    progressPercentage =
                        progressPercentage > 100 ? 100 : progressPercentage;
                  }

                  percentageMap[release.name] = progressPercentage;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.darkModeSwitch
                            ? Colors.grey
                            : Colors.white, // 컨테이너의 배경색
                        borderRadius:
                            BorderRadius.circular(10.0), // 컨테이너의 모서리를 둥글게 만듭니다.
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.5), // 그림자 색상 및 불투명도
                            spreadRadius: 5, // 그림자 확산 정도
                            blurRadius: 7, // 그림자 흐림 정도
                            offset: Offset(0, 3), // 그림자 위치 (가로, 세로)
                          ),
                        ],
                      ),
                      child: Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.blue, // 스와이프할 때 나타날 배경 색상
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.edit, // 삭제 아이콘
                                    color: Colors.white,
                                    size: 50 // 아이콘 색상
                                    ),
                                Text(
                                  '수정',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red, // 스와이프할 때 나타날 배경 색상
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete, size: 50, // 삭제 아이콘
                                  color: Colors.white, // 아이콘 색상
                                ),
                                Text(
                                  '삭제',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            if (direction == DismissDirection.endToStart) {
                              // 왼쪽으로 스와이프할 때 수행할 동작
                              setState(() {
                                releaseFirestore.deleteRelease(release.id!);
                              });
                              ShowToast('삭제되었습니다.', 1);
                            } else if (direction ==
                                DismissDirection.startToEnd) {
                              // 오른쪽으로 스와이프할 때 수행할 동작
                              print(release.id);
                              Get.to(ReleaseClaculatorEdit(release: release));
                            }
                          });
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          trailing: Column(
                            children: [
                              Text(
                                '${percentageMap[release.name]!.toStringAsFixed(0)}%',
                                style: TextStyle(fontSize: 26),
                              ),
                            ],
                          ),
                          title: Text(
                            '${release.name}\n',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LinearProgressIndicator(
                                minHeight: 10,
                                value: percentageMap[release.name]!.isFinite
                                    ? percentageMap[release.name]! / 100
                                    : 0.0,
                                backgroundColor: Colors.grey,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                              SizedBox(height: 24),
                              Text(
                                '입소일:  ${DateFormat('yyyy-MM-dd').format(release.inputDate).toString()}',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '형   량:  ${release.years}년 ${release.months}개월',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '출소일: ${DateFormat('yyyy-MM-dd').format(releaseDate)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
