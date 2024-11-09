import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:app_movil/controllers/activities_controller.dart';

class ProgressCircle extends StatelessWidget {
  final ActivitiesController controller = Get.find<ActivitiesController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Calcular porcentaje de actividades booleanas
      int totalBooleanActivities = controller.booleanActivities.length;
      int checkedBooleanActivities = controller.checkedBooleanActivities;
      double booleanProgress = totalBooleanActivities > 0
          ? checkedBooleanActivities / totalBooleanActivities
          : 0.0;

      // Calcular porcentaje de actividades cuantitativas
      int totalQuantitativeActivities = controller.quantitativeActivities.length;
      double quantitativeProgress = 0.0;

      if (totalQuantitativeActivities > 0) {
        double completedQuantitative = controller.quantitativeActivities
            .map((activity) => activity.values.first['current']! /
                activity.values.first['initial']!)
            .reduce((a, b) => a + b); // Sumar los porcentajes de cada actividad

        quantitativeProgress = completedQuantitative / totalQuantitativeActivities;
      }

      // Calcular el progreso total (50% booleano y 50% cuantitativo)
      double totalProgress = (booleanProgress * 0.5) + (quantitativeProgress * 0.5);

      return CircularPercentIndicator(
        radius: 100.0,
        lineWidth: 10.0,
        percent: totalProgress.clamp(0.0, 1.0), // Asegurarse de que esté entre 0 y 1
        center: Text(
          "${(totalProgress * 100).toStringAsFixed(1)}%", // Muestra el porcentaje en el centro
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        progressColor: Colors.teal, // Color del progreso
        backgroundColor: Colors.grey[300]!, // Color de fondo
        circularStrokeCap: CircularStrokeCap.round, // Bordes redondeados
      );
    });
  }
}
