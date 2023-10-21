import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';

class DarkSwitch extends StatefulWidget {
  const DarkSwitch({super.key});

  @override
  State<DarkSwitch> createState() => _DarkSwitchState();
}

class _DarkSwitchState extends State<DarkSwitch> {
  final controller = Get.put(ControllerGetX());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '다크모드설정',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                Column(
                  children: [
                    Switch(
                        value: controller.darkModeSwitch,
                        onChanged: (value) {
                          setState(() {
                            controller.darkModeSwitch = value;
                            Get.changeTheme(controller.darkModeSwitch
                                ? ThemeData.dark()
                                : ThemeData.light());
                          });
                        }),
                    Text(
                      controller.darkModeSwitch ? "Dark Mode" : "Light Mode",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: controller.darkModeSwitch
                              ? Colors.white
                              : Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
