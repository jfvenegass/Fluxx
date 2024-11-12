import 'package:app_movil/controllers/activities_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StreakWidget extends StatelessWidget {
  const StreakWidget({super.key, required int streak});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ActivitiesController>();
    return Obx(() {
      return Row(
        children: [
          const Icon(Icons.local_fire_department, color: Colors.red, size: 24),
          const SizedBox(width: 4.0),
          Text(
            '${controller.streak.value}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );
    });
  }
}
