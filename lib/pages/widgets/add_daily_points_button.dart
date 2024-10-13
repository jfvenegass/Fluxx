import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_movil/controllers/activities_controller.dart';

class AddDailyPointsButton extends StatelessWidget {
  final controller = Get.find<ActivitiesController>();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        controller.addDailyPointsToTotal();
        controller.resetDailyPoints();
      },
      child: Text('Añadir puntos diarios'),
    );
  }
}