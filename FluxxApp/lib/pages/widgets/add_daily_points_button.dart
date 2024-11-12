import 'package:app_movil/controllers/activities_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDailyPointsButton extends StatelessWidget {
  const AddDailyPointsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ActivitiesController>();
    return ElevatedButton(
      onPressed: () {
        controller.dailyPoints.value += 100;
      },
      child: const Text('Añadir puntos diarios'),
    );
  }
}
