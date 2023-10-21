import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/Widget/ScheduleList.dart';
import 'package:navi_project/Widget/schedule_firebase.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/model/schedule_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  //Property
  final scheduleFirestore = ScheduleFirestore();
  final controller = Get.put(ControllerGetX());
  TextEditingController scheduleTextController = TextEditingController();
  // Firebase Firestore 인스턴스 생성
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime(
    //유저가 선택한 날짜
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now(); //선택한 날짜
  TimeOfDay selectedTime = TimeOfDay.now(); // 현재의 날짜
//카렌더 날짜선택
  Future<void> _selectTime(
      BuildContext context, Function(TimeOfDay) updateTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        updateTime(selectedTime); // Call the callback to update UI
      });
    }
  }

  //일정 입력을 위한 다이얼로그
  Future<void> _showScheduleDialog(
      BuildContext context, Function(TimeOfDay) updateTime) async {
    TimeOfDay newTime = selectedTime;
    final TextEditingController scheduleController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('일정을 입력해 주세요'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        '${newTime.format(context)}',
                        style: TextStyle(fontSize: 18),
                      ),
                      TextButton(
                        onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: newTime,
                          );
                          if (picked != null) {
                            setState(() {
                              newTime = picked;
                              updateTime(picked);
                            });
                          }
                        },
                        child: Text('시간선택'),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: scheduleController,
                    decoration: InputDecoration(labelText: 'Schedule'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final enteredSchedule = scheduleController.text;
                      final schedule = FirebaseScheduleModel(
                        id: 'unique_id',
                        title: enteredSchedule,
                        year: focusedDay.year,
                        month: focusedDay.month,
                        day: focusedDay.day,
                        date: focusedDay,
                        time: newTime.format(context),
                        finish: false,
                        createdAt: DateTime.now(),
                      );
                      final service = ScheduleFirestore();
                      await service.addSchedule(schedule);
                      Navigator.of(context).pop();
                    },
                    child: Text('저장'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    scheduleTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Schedule"),
        actions: [
          IconButton(
            onPressed: () async {
              _showScheduleDialog(context, (TimeOfDay updatedTime) {
                // if (updatedTime != null) {
                setState(() {
                  selectedTime = updatedTime;
                });
                // }
              });
            },
            icon: Icon(Icons.add),
            iconSize: 25,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            child: TableCalendar(
              locale: 'ko_Kr', //언어설정
              firstDay: DateTime.utc(2010, 1, 1),
              lastDay: DateTime.utc(2050, 12, 31),
              focusedDay: focusedDay,
              calendarFormat: format,
              onFormatChanged: (CalendarFormat format) {
                setState(() {
                  this.format = format;
                });
              },
              onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                // 선택된 날짜의 상태를 갱신합니다.
                setState(() {
                  this.selectedDay = selectedDay;
                  this.focusedDay = focusedDay;
                });
              },
              selectedDayPredicate: (DateTime day) {
                // selectedDay 와 동일한 날짜의 모양을 바꿔줍니다.
                return isSameDay(selectedDay, day);
              },
            ),
          ),
          ScheduleList(
            scheduleStream: scheduleFirestore.getScheduleList(),
            selectedDay: selectedDay, // 선택된 날짜 전달
          ), //스케쥴이 존재하면 스케쥴을 뿌려줌

          // Positioned(
          //   bottom: 0,
          //   left: 10,
          //   child: Container(
          //     child: FloatingActionButton(
          //       onPressed: () async {
          //         _showScheduleDialog(context, (TimeOfDay updatedTime) {
          //           // if (updatedTime != null) {
          //           setState(() {
          //             selectedTime = updatedTime;
          //           });
          //           // }
          //         });
          //       },
          //       child: Icon(Icons.add),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
