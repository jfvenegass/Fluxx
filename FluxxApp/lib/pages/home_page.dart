import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activities_controller.dart';
import 'widgets/activities_details.dart';
import 'widgets/activities_modales.dart';
import 'widgets/add_daily_points_button.dart';
import 'widgets/barra_navegacion.dart';
import 'widgets/progress_circle.dart';
import 'widgets/streak_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final activitiesController = Get.find<ActivitiesController>();
    int selectedIndex = 1; // Índice inicial de la barra de navegación

    // Función para manejar el clic en "Añadir"
    void onAddButtonPressed() {
      // Mostrar el diálogo para seleccionar tipo de actividad (única o repetible)
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Seleccionar tipo de actividad'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  showAddActivityDialog(context, 'boolean'); // Actividad Única
                },
                child: const Text('Actividad Única'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  showAddActivityDialog(context, 'quantitative'); // Actividad Repetible
                },
                child: const Text('Actividad Repetible'),
              ),
            ],
          );
        },
      );
    }

    void onItemTapped(int index) {
      if (index == 1) {
        // Home ya está seleccionado
        return;
      } else if (index == 2) {
        // Redirigir a la página de usuario
        Navigator.pushNamed(context, '/user_info');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluxx - Home'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreakWidget(streak: activitiesController.streak.value),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              // Calculamos el progreso total
              final totalProgress =
                  activitiesController.quantitativeActivities.fold<double>(0.0,
                      (sum, activity) {
                final data = activity.values.first;
                final initial = data['initial'] ?? 0;
                final current = data['current'] ?? 0;

                if (initial > 0) {
                  return sum + (current / initial);
                }
                return sum;
              });

              final normalizedProgress =
                  activitiesController.quantitativeActivities.isNotEmpty
                      ? totalProgress /
                          activitiesController.quantitativeActivities.length
                      : 0.0;

              return ProgressCircle(progress: normalizedProgress);
            }),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: AddDailyPointsButton(),
          ),
          const Expanded(
            child: ActivitiesDetails(), // Muestra las actividades dinámicamente
          ),
        ],
      ),
      bottomNavigationBar: BarraNavegacion(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
        onAddButtonPressed: onAddButtonPressed, // Aquí pasamos la función
      ),
    );
  }
}
