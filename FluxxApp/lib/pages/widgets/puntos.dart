import 'package:app_movil/controllers/activities_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showConfirmationDialog(BuildContext context) {
  final controller = Get.find<ActivitiesController>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Deseas añadir los puntos diarios al total?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.dailyPoints.value += 10; // Ejemplo: Incremento fijo
              Navigator.of(context).pop();
            },
            child: const Text('Añadir'),
          ),
        ],
      );
    },
  );
}
