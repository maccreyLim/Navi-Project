import 'package:flutter/material.dart';

class Announcement extends StatelessWidget {
  final List<AnnouncetList> announceList;

  const Announcement({Key? key, required this.announceList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(" - 공 지 사 항 -"),
        Expanded(
          child: ListView.builder(
            itemCount: announceList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Handle tap event here
                  // Example: navigate to a details page
                  // String title = announceList[index].title;
                  // String contents = announceList[index].contents;
                  // Do something with title and contents
                },
                child: ListTile(
                  title: Text(announceList[index].title),
                  subtitle: Text(announceList[index].contents),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AnnouncetList {
  // Property
  String title;
  String contents;

  // Constructor
  AnnouncetList({
    required this.title, // required 반드시 있어야할 인자
    required this.contents,
  });
}
