import 'package:flutter/material.dart';
import 'package:app_movil/controllers/activities_controller.dart';
  
  void showConfirmationDialog(BuildContext context, ActivitiesController controller) {
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
                controller.addDailyPointsToTotalAndResetActivities(context);
                
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
