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
  final controller = Get.put(ControllerGetX());

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        AnnouncetListModel announcetList = AnnouncetListModel(
          authorUid: controller.userUid,
          authorNickname: controller.userData['nickName'] ?? "",
          isLiked: false,
          likeCount: 0,
          title: 'title',
          content: 'content',
          createdAt: DateTime.now(),
          documentFileID: "", // 필요한 필드
        );

        await AnnouncementFirebaseService().createAnnouncetList(announcetList);

        ShowToast('게시물이 성공적으로 저장되었습니다.', 1);
        Get.off(const HomeScreen());
      },
      child: const Text('저장'),
    );
  }
}
