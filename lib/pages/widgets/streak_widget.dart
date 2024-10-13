import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_movil/controllers/activities_controller.dart';

class StreakWidget extends StatelessWidget {
  final controller = Get.find<ActivitiesController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      children: [
        Icon(Icons.local_fire_department, color: Colors.red, size: 24),
        const SizedBox(width: 4.0),
        Text(
          '${controller.streak}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ));
  }
}