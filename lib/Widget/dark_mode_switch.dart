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
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                              controller.darkModeSwitch
                                  ? "Dark Mode"
                                  : "Light Mode",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: controller.darkModeSwitch
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
