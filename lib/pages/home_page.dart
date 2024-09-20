import 'package:app_movil/controllers/activities_controller.dart';
import 'package:app_movil/pages/activities_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showConfirmationDialog(BuildContext context, ActivitiesController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Deseas añadir los puntos diarios al total?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.addDailyPointsToTotal();
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ActivitiesController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nombre de la App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Mostrar el nombre de la app y el número total de actividades
            const Text(
              'Nombre de la App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            // Número total de actividades
            Obx(() => Text(
              'Actividades totales: ${controller.totalActivities}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )),
            const SizedBox(height: 16.0),
            // Número de actividades booleanas chequeadas
            Obx(() => Text(
              'Actividades booleanas chequeadas: ${controller.checkedBooleanActivities}',
              style: const TextStyle(
                fontSize: 18,
              ),
            )),
            const SizedBox(height: 16.0),
            // Número de actividades cuantitativas realizadas
            Obx(() => Text(
              'Actividades cuantitativas realizadas al menos una vez: ${controller.completedQuantitativeActivities}',
              style: const TextStyle(
                fontSize: 18,
              ),
            )),
            const SizedBox(height: 16.0),
            // Puntajes
            Obx(() => Column(
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
                  child: const Text('Añadir puntos al total'),
                ),
              ],
            )),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Navegar a ActivitiesDetailsScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ActivitiesDetailsScreen(),
                  ),
                );
              },
              child: const Text('Detalles'),
            ),
          ],
        ),
      ),
    );
  }
}
