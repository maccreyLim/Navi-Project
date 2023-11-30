import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/message/message_firebase.dart';
import 'package:navi_project/message/message_model.dart';

class MemberMessageCreateScrren extends StatefulWidget {
  final String uid;
  final String nickName;
  const MemberMessageCreateScrren(
      {super.key, required this.uid, required this.nickName});

  @override
  State<MemberMessageCreateScrren> createState() =>
      __MemberMessageCreateScrrenState();
}

class __MemberMessageCreateScrrenState
    extends State<MemberMessageCreateScrren> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();
  TextEditingController sendUserController = TextEditingController();
  // 수신자의 UID를 저장하는 변수
  String receiverUid = "";
  // 수신자의 nickName를 저장하는 변수
  String receivernickName = "";
  final MassageFirebase _mfirebase =
      MassageFirebase(); // MessageFirebase 클래스의 인스턴스 생성
  final controller = Get.put(ControllerGetX());

  @override
  void initState() {
    receiverUid = widget.uid;
    receivernickName = widget.nickName;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    sendUserController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //다른 곳을 터치하면 키보두룰 내림
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('To $receivernickName'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // 세로 방향 가운데 정렬
                      crossAxisAlignment:
                          CrossAxisAlignment.center, // 가로 방향 가운데 정렬
                      children: [
                        TextFormField(
                          style: const TextStyle(fontSize: 16),
                          cursorHeight: 20,
                          maxLines: 12,
                          controller: messageController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            labelText: "메시지",
                          ),
                          maxLength: 100,
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "메시지를 입력해주세요";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 120,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            //  Todo: MessageFirebase에서 메시지 등록
                            if (_formkey.currentState!.validate()) {
                              Message message = Message(
                                  senderUid: controller.userUid,
                                  receiverUid: receiverUid,
                                  contents: messageController.text,
                                  timestamp: DateTime.now());
                              _mfirebase.createMessage(
                                  message, sendUserController.text);
                              Get.back();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 1, 48)),
                          child: Text(
                            '$receivernickName 님에게 쪽지 보내기',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
