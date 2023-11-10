import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/message/massage_create_screen.dart';
import 'package:navi_project/message/received_screen.dart' as ReceivedScreen;
import 'package:navi_project/message/send_screen.dart' as SendScreen;

class MessageStateScreen extends StatefulWidget {
  const MessageStateScreen({super.key});

  @override
  State<MessageStateScreen> createState() => _MessageStateScreenState();
}

class _MessageStateScreenState extends State<MessageStateScreen> {
  //Property
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    ReceivedScreen.ReceivedScreen(), // 받은 쪽지함 화면
    SendScreen.SendScreen(), // 보낸 쪽지함 화면
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('쪽지함'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: '받은 쪽지함',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: '보낸 쪽지함',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // 선택된 아이템의 색상
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.to(MessageCreateScrren());
        },
      ),
    ));
  }
}
