//Dark테마변경을 위한 스위칭import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';

class AdminModeSwitch extends StatefulWidget {
  const AdminModeSwitch({super.key});

  @override
  State<AdminModeSwitch> createState() => _AdminModeSwitchState();
}

class _AdminModeSwitchState extends State<AdminModeSwitch> {
  final controller = Get.put(ControllerGetX());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              const Text(
                '관리자모드 설정',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() => Switch(
                          value: controller.adminModeSwich.value,
                          onChanged: (value) {
                            controller.adminModeSwich.value = value;
                            setState(() {});
                          },
                        )),
                  ),
                  Text(
                    controller.adminModeSwich.value
                        ? "Admin Mode"
                        : "Normal Mode",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: controller.adminModeSwich.value
                          ? Colors.redAccent
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
