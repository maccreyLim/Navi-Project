import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/Widget/announcement_firebase.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/home/home_screen.dart';

import '../model/announcetList_model .dart';

class AnnouncetListModelCreateScreen extends StatefulWidget {
  const AnnouncetListModelCreateScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncetListModelCreateScreen> createState() =>
      _AnnouncetListModelCreateScreenState();
}

class _AnnouncetListModelCreateScreenState
    extends State<AnnouncetListModelCreateScreen> {
  //Property
  TextEditingController titleController = TextEditingController();
  TextEditingController contentsController = TextEditingController();
  final controller = Get.put(ControllerGetX());
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentsController.dispose();
  }

  Widget saveButton() {
    return ElevatedButton(
      onPressed: () async {
        AnnouncetListModel announcetList = AnnouncetListModel(
          authorUid: controller.userUid,
          authorNickname: controller.userData['nickName'] ?? "",
          isLiked: false,
          likeCount: 0,
          title: titleController.text, // 입력 필드의 값 사용
          content: contentsController.text, // 입력 필드의 값 사용
          createdAt: DateTime.now(),
          documentFileID: "", // 필요한 필드
        );

        await AnnouncementFirebaseService().createAnnouncetList(announcetList);

        ShowToast('게시물이 성공적으로 저장되었습니다.', 1);
        Get.off(HomeScreen());
      },
      child: const Text('저장'),
    );
  }

  Widget inputText(TextEditingController name, String nametext, int line) {
    return Row(
      children: [
        Text(
          '${nametext}',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              maxLines: line,
              controller: name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                hintText: "",
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return "${nametext}을 입력해주세요";
                }
                return null;
              }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('공지사항작성 (관리자용)'),
        ),
        body: Column(
          children: [
            Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      inputText(titleController, "제목", 1),
                      SizedBox(
                        height: 15,
                      ),
                      inputText(contentsController, "내용", 18),
                      SizedBox(height: 50),
                      saveButton(),
                    ],
                  ),
                ))
          ],
        ));
  }
}
