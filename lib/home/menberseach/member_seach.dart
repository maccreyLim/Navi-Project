import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/home/menberseach/member_messge_create_screen.dart';
import 'package:navi_project/message/massage_create_screen.dart';
import 'package:navi_project/message/message_firebase.dart';

class MemberSeach extends StatefulWidget {
  const MemberSeach({super.key});

  @override
  State<MemberSeach> createState() => _MemberSeachState();
}

class _MemberSeachState extends State<MemberSeach> {
  //Property
  final _formkey = GlobalKey<FormState>();
  final _seach = SearchController();
  // MessageFirebase 클래스의 인스턴스 생성
  final MassageFirebase _mfirebase = MassageFirebase();
  // 검색 결과를 저장할 변수
  Map<String, dynamic> searchResults = {};
  final controller = Get.put(ControllerGetX());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원검색'),
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
                const Text('검색 결과:'),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final user = searchResults.keys.elementAt(index);
                    final userData = searchResults[user];

                    final nickname = userData['nickname'] as String;

                    return ListTile(
                        trailing: userData['parters']
                            ? Container(
                                alignment: Alignment.center,
                                width: 40,
                                height: 24,
                                color: Colors.redAccent,
                                child: const Text('인증',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              )
                            : const Text(''),
                        title: Text(nickname),
                        onTap: () {
                          const Text('회원 프로필');
                          setState(() {
                            //todo :아이디를 클릭하면 상세내용 보여주기
                            showDialog(
                              context: context,
                              barrierDismissible: true, //바깥 영역 터치시 닫을지 여부 결정
                              builder: ((context) {
                                return AlertDialog(
                                  backgroundColor: Colors.green[100],
                                  title: Text(
                                    "$nickname",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  content: Row(
                                    children: [
                                      userData['photoUrl'] != ""
                                          ? Container(
                                              width: 80,
                                              height: 80,
                                              child: Image.network(
                                                userData['photoUrl'].toString(),
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Container(
                                              width: 80,
                                              height: 80,
                                              child: Image.asset(
                                                  'assets/images/navi_logo_text.png',
                                                  fit: BoxFit.cover),
                                            ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (userData['parters'])
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${userData['workspace'].toString()}',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    '${userData['occupation'].toString()}',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              )
                                            else
                                              Text('일반회원'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    Container(
                                      child: IconButton(
                                        onPressed: () {
                                          Get.to(MemberMessageCreateScrren(
                                            uid: userData['uid'],
                                            nickName: nickname,
                                          ));
                                        },
                                        icon: Icon(Icons.message_outlined),
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Container(
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); //창 닫기
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            );
                          });
                        },
                        leading: Icon(Icons.person_add));
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(controller.userData.string),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
