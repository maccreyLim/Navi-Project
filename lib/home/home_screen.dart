import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/Widget/announcement_firebase.dart';
import 'package:navi_project/Widget/home_advertisement.dart';
import 'package:navi_project/home/announce_list_model_create_screen.dart';
import 'package:navi_project/home/log/logout/logout_screen.dart';
import 'package:navi_project/message/message_state_screen.dart';
import 'package:navi_project/model/announcetList_model%20.dart';
import 'package:navi_project/post/post_screen.dart';
import 'package:navi_project/home/log/login/log_in_screen.dart';
import 'package:navi_project/home/setting/profileupdate_screen.dart';
import 'package:navi_project/home/setting/setting_screen.dart';
import 'package:navi_project/release_calculator_screen/release_calculator_screen.dart';
import 'package:navi_project/push_massage/notification.dart';
import 'package:navi_project/schedule/schedulescreen.dart';
import 'package:icon_badge/icon_badge.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//Property
// Firebase Firestore로부터 공지사항을 가져오기 위한 쿼리
  final Query query = FirebaseFirestore.instance.collection('announcement');
// // Firebase Authentication을 사용하기 위한 인스턴스
//   final FirebaseAuth _auth = FirebaseAuth.instance;
// GetX 컨트롤러 인스턴스
  final controller = Get.put(ControllerGetX());

  @override
  void initState() {
    FlutterLocalNotification.init();

    Future.delayed(const Duration(seconds: 3), () async {
      FlutterLocalNotification.requestNotificationPermission();
      // 메시지 카운트 가져오기
      if (controller.isLogin) {
        await for (int count in getUnreadMessageCountStream()) {
          setState(() {
            controller.setMessageCount(count);
          });
        }
      }
    });

    super.initState();
  }

//메시지 갯수를 스트림으로 확인
  Stream<int> getUnreadMessageCountStream() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      Stream<QuerySnapshot> snapshots = _firestore
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .snapshots();

      return snapshots.map((QuerySnapshot querySnapshot) {
        return querySnapshot.size;
      });
    } catch (e) {
      print('오류 발생: $e');
      // 오류 처리 코드를 추가하거나 throw로 예외를 다시 던질 수 있습니다.
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//오른쪽 상단 로그아웃버튼 & 설정 버튼 구현
        actions: [
          Obx(() => IconBadge(
                icon: const Icon(Icons.notifications, color: Colors.lightBlue),
                itemCount: controller.messageCount.value, // itemCount를 변수로 설정
                badgeColor: Colors.redAccent,
                itemColor: Colors.white,
                maxCount: 99,
                hideZero: true,
                onTap: () {
                  Get.to(const MessageStateScreen());
                },
              )),
          IconButton(
            onPressed: () async {
              // 로그인 및 로그아웃 구현
              if (controller.isLogin) {
                Get.to(const LogoutScreen());
              } else {
                Get.to(const LoginScreen());
              }
            },
            icon: controller.isLogin
                ? const Icon(Icons.logout)
                : const Icon(Icons.login), // 이 위치에 아이콘 설정을 넣어야 합니다.
          ),
          IconButton(
            onPressed: () {
              Get.offAll(const SettingScreen());
            },
            icon: const Icon(Icons.settings),
          ),
        ],
        title: const Text("Home Screen"),
        centerTitle: false,
      ),
//Drawer 메뉴 구현
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
//GetX를 이용하여 프로필 사진이 변경시 즉시 반영
              currentAccountPicture: Obx(() {
                final photoUrl = controller.userData['photoUrl'];
                if (photoUrl == null || photoUrl.isEmpty) {
                  return const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/navi_logo_text.png'),
                  );
                } else {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(photoUrl),
                    maxRadius: 30,
                  );
                }
              }),
//GetX를 이용하여 방문수를 표시 만약 로그아웃상태일 경우 로그아웃 표시
              accountName: Obx(() {
                if (controller.userData['visitCount'] == null) {
                  return const Text('현재상태 : 로그아웃');
                } else {
                  return Text(
                      '현재상태: ${controller.userData['visitCount']}번째 로그인');
                }
              }),
//GetX를 이용하여 로그인 계정을 표시 만약 로그아웃상태일 경우 로그인계정 없음 표시
              accountEmail: Obx(() {
                if (controller.userData['email'] == null) {
                  return const Text("로그인계정 : 없음");
                } else {
                  return Text("로그인계정: ${controller.userData['email']}");
                }
              }),
              onDetailsPressed: () {
                Get.to(() => const ProfileUpdateScreen());
              },
              decoration: BoxDecoration(
//다크모드 체크
                color: controller.darkModeSwitch
                    ? Colors.grey[800]
                    : Colors.blue, // 다크 모드에 따라 컬러 변경
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.door_sliding_outlined),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: const Text('게시판'),
              onTap: () {
                // 게시판으로 이동할 수 있는 로직 추가
                Get.to(const PostScreen());
              },
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: const Text('Schedule'),
              onTap: () {
                // 스케줄 화면으로 이동할 수 있는 로직 추가
                Get.to(const ScheduleScreen());
              },
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: const Text('출소일 계산기'),
              onTap: () {
                // 이자계산기 화면으로 이동할 수 있는 로직 추가
                Get.to(const ReleaseCalculatorScreen());
              },
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: const Text('회원검색'),
              onTap: () {
                // 회원검색으로 이동할 수 있는 로직 추가
              },
              trailing: const Icon(Icons.navigate_next),
            ),
            // if (controller.isLogin)
            ListTile(
              leading: const Icon(Icons.settings),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: const Text('프로필 설정'),
              onTap: () {
                // 프로필 업데이트 화면으로 이동하는 로직 추가
                Get.offAll(() => const ProfileUpdateScreen());
              },
              trailing: const Icon(Icons.navigate_next),
            ),
          ],
        ),
      ),
//Body 부분 구현
      body: Column(
        children: [
          const HomeAdverticement(),
          const SizedBox(
            height: 30,
          ),
// 공지사항 도입부분
          const Text(
            " - 공 지 사 항 -",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
//파이어베이스 스트림빌터 쿼리를 이용하여 공지사항 가지고 오기(추후 공지사항이 많아지면 가지고 오는 데이타양 한정 필요)
          Container(
              child: StreamBuilder<QuerySnapshot>(
            stream: query.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Text('공지사항 데이터를 가져오는 중 오류가 발생했습니다.');
              }

              final querySnapshot = snapshot.data;
              if (querySnapshot == null || querySnapshot.docs.isEmpty) {
                return const Text('공지사항이 없습니다.');
              }

              final announcementList = querySnapshot.docs
                  .map((doc) => AnnouncetListModel.fromMap(
                      doc.data() as Map<String, dynamic>))
                  .toList();
              announcementList.sort(
                  (a, b) => b.createdAt.compareTo(a.createdAt)); // 내림차순 정렬
              return SingleChildScrollView(
                  child: buildCommentListView(announcementList));
            },
          )),

//공지사항 작성을 위해 필요한 버튼 ( 회원데이타에서 관리자인경우와 관리자 모드를 켰을때만 보이게 구현)
          ElevatedButton(
            onPressed: () {
              Get.to(const AnnouncetListModelCreateScreen());
              setState(() {});
            },
            child: const Text('공지사항 작성'),
          ),
//플러터 로컬 알림을 구현
          MaterialButton(
            onPressed: () => FlutterLocalNotification.showNotification(
                "새로운 메시지가 도책했습니다.",
                '총 ${controller.messageCount}개의 메지시를 확인하세요'),
            child: const Text("알림 보내기"),
          ),
        ],
      ),
    );
    //DarkMode 스위치
  }

//공지사항 리스트뷰빌더로 구현
  Widget buildCommentListView(List<AnnouncetListModel> announcementList) {
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        child: SizedBox(
          height: 210,
          child: ListView.builder(
            itemCount: announcementList.length,
            itemBuilder: (context, index) {
              final comment = announcementList[index];
//작성시간과 얼마나 지났는지 표시를 위한 함수 구현
              final DateTime created = comment.createdAt;
              final Duration difference = now.difference(created);

              String formattedDate;

              if (difference.inHours > 0) {
                formattedDate = '${difference.inHours}시간 전';
              } else if (difference.inMinutes > 0) {
                formattedDate = '${difference.inMinutes}분 전';
              } else {
                formattedDate = '방금 전';
              }
//리스트 타이틀로 구현
              return ListTile(
                title: Text(
                  "${comment.title} ($formattedDate)",
                  maxLines: 1, // 최대 줄 수를 1로 설정
                  overflow: TextOverflow.ellipsis, // 오버플로우 처리 설정 (생략 부호 사용)),
                ),
                subtitle: Text(
                  comment.content,
                  maxLines: 1, // 최대 줄 수를 1로 설정
                  overflow: TextOverflow.ellipsis, // 오버플로우 처리 설정 (생략 부호 사용)
                ),
                trailing: Visibility(
                  visible: controller.userUid == comment.authorUid,
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      // 댓글 삭제 로직을 추가하세요.
                      String documentFileID = comment.documentFileID.toString();
//파이어베이스에서 공지사항 삭제 구현
                      AnnouncementFirebaseService()
                          .deleteAnnouncetList(documentFileID);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void showLocalNotification(String title, String body) {
    FlutterLocalNotification.showNotification(title, title);
  }
}
