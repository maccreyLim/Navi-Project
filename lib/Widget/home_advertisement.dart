import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

class HomeAdverticement extends StatefulWidget {
  const HomeAdverticement({super.key});

  @override
  State<HomeAdverticement> createState() => _HomeAdverticementState();
}

class _HomeAdverticementState extends State<HomeAdverticement> {
  //Property
  PageController pageController = PageController(); //Page 컨트롤
  int bannerIndex = 0; //배너의 Index를 담고 있음

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          height: 240,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          child: PageView(
            controller: pageController,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: Image.asset(
                  "assets/images/banner_01.png",
                  height: 240,
                  fit: BoxFit.fill, //설정한 크기에 맞게 비율이 변경되어 채워짐
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: Image.asset(
                  "assets/images/banner_02.png",
                  height: 240,
                  fit: BoxFit.fill, //설정한 크기에 맞게 비율이 변경되어 채워짐
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: Image.asset(
                  "assets/images/banner_03.png",
                  height: 240,
                  fit: BoxFit.fill, //설정한 크기에 맞게 비율이 변경되어 채워짐
                ),
              ),
            ],
            onPageChanged: (value) {
              setState(
                () {
                  bannerIndex = value;
                },
              );
            },
          ),
        ),
        DotsIndicator(
          //인디케이터를 활성화
          dotsCount: 3, //인디케이터 점의 갯수
          position: bannerIndex, //   bannerIndex에 의해 인디케이터 포지션 변경
          decorator: DotsDecorator(
            size: const Size.square(9.0),
            activeSize: const Size(28.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ]),
    );
  }
}
