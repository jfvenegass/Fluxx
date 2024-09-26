import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_movil/controllers/activities_controller.dart';

class PuntosWidget extends StatelessWidget {
  const PuntosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ActivitiesController controller = Get.find();

    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Puntos diarios: ${controller.dailyPoints}',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Puntos totales: ${controller.totalPoints}',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            _showConfirmationDialog(context, controller);
          },
          child: const Text('Añadir puntos diarios al total'),
        ),
      ],
    ));
  }

  void _showConfirmationDialog(BuildContext context, ActivitiesController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Deseas añadir los puntos diarios al total y reiniciar las actividades?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Añadir puntos al total y reiniciar actividades
                controller.addDailyPointsToTotalAndResetActivities();
                
                // Cerrar el diálogo
                Navigator.of(context).pop();
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }
}
