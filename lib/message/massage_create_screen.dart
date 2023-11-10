import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/message/message_firebase.dart';
import 'package:navi_project/message/message_model.dart';
import 'package:navi_project/message/message_state_screen.dart';

class MessageCreateScrren extends StatefulWidget {
  const MessageCreateScrren({super.key});

  @override
  State<MessageCreateScrren> createState() => _MessageCreateScrrenState();
}

class _MessageCreateScrrenState extends State<MessageCreateScrren> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();
  TextEditingController sendUserController = TextEditingController();
  String receiverUid = ''; // 수신자의 UID를 저장하는 변수
  final _seach = SearchController();
  final MassageFirebase _mfirebase =
      MassageFirebase(); // MessageFirebase 클래스의 인스턴스 생성
  Map<String, dynamic> searchResults = {}; // 검색 결과를 저장할 변수
  final controller = Get.put(ControllerGetX());

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    sendUserController.dispose();
    _seach.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('쪽지 보내기'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SearchBar(
                    controller: _seach,
                    hintText: '회원검색',
                    leading: const Icon(Icons.search),
                    onChanged: (v) async {
                      Map<String, dynamic> results =
                          await _mfirebase.getUserByNickname(v);
                      setState(() {
                        searchResults = results; // 검색 결과를 저장
                      });
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text('검색 결과:'),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final user = searchResults.keys.elementAt(index);
                      final userData = searchResults[user];

                      final nickname = userData['nickname'] as String;
                      final photoUrl = userData['photoUrl'];

                      return ListTile(
                        title: Text(nickname),
                        onTap: () {
                          setState(() {
                            sendUserController.text = nickname;

                            //UID 저장
                            receiverUid = user;
                          });
                        },
                        leading: photoUrl != null
                            ? Image.network(photoUrl)
                            : Image.asset('assets/images/navi_logo.png'),
                      );
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 16),
                    cursorHeight: 20,
                    maxLines: 1,
                    controller: sendUserController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: "보낼사람",
                    ),
                    onChanged: (query) {
                      // 닉네임을 기반으로 수신자 UID 가져오기
                      // messageFirebase.getUidByNickname(query).then((uid) {
                      //   setState(() {
                      //     receiverUid = uid ?? ''; // 결과가 없으면 빈 문자열
                      //   });
                      // });
                    },
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "보낼사람을 입력해주세요";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 16),
                    cursorHeight: 20,
                    maxLines: 5,
                    controller: messageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: "메시지",
                    ),
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "메시지를 입력해주세요";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //  Todo: MessageFirebase에서 메시지 등록

                      Message message = Message(
                          senderUid: controller.userUid,
                          receiverUid: receiverUid,
                          contents: messageController.text,
                          timestamp: DateTime.now());
                      _mfirebase.createMessage(
                          message, sendUserController.text);
                      Get.off(MessageStateScreen());
                    },
                    child: Text('보내기'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
