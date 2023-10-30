import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/model/schedule_model.dart';

class ScheduleList extends StatelessWidget {
  final Stream<List<FirebaseScheduleModel>> scheduleStream;
  final DateTime selectedDay;
  final controller = Get.put(ControllerGetX());

  ScheduleList(
      {super.key, required this.scheduleStream, required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FirebaseScheduleModel>>(
      stream: scheduleStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List<FirebaseScheduleModel> scheduleList = snapshot.data ?? [];
          final selectedDateSchedules = scheduleList.where((schedule) {
            final scheduleDate = schedule.date.toLocal();
            return scheduleDate.year == selectedDay.year &&
                scheduleDate.month == selectedDay.month &&
                scheduleDate.day == selectedDay.day;
          }).toList();
          //데이타 시간으로 소팅
          selectedDateSchedules.sort((a, b) {
            final timeA = a.time;
            final timeB = b.time;
            return timeA.compareTo(timeB);
          });

          return Column(
            children: [
              // Text(
              //   DateFormat('M월 d일', 'ko_KR').format(selectedDay),
              //   style: TextStyle(fontSize: 18),
              // ),
              for (final schedule in selectedDateSchedules)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  margin: EdgeInsets.all(5.0),
                  child: ListTile(
                    leading: Text(
                      '${schedule.time}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    title: Text(
                      schedule.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        deleteSchedule(schedule.id); // //파이어베이스 삭제 구현
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ),
                ),
            ],
          );
        }
      },
    );
  }

  Future<void> deleteSchedule(String scheduleId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(controller.userUid)
          .collection(
              'schedules') // 'schedules'는 파이어베이스 컬렉션의 이름입니다. 필요에 따라 수정하세요.
          .doc(scheduleId) // 스케줄의 고유 ID
          .delete();
    } catch (e) {
      ShowToast('일정을 삭제하지 못했습니다.', 1);
    }
  }
}
