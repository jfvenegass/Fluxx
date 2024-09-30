import 'package:app_movil/controllers/activities_controller.dart';
import 'package:app_movil/pages/widgets/activities_modales.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_movil/pages/widgets/barra_navegacion.dart'; 


class ActivitiesDetailsScreen extends StatefulWidget {
  const ActivitiesDetailsScreen({super.key});

  @override
  _ActivitiesDetailsScreenState createState() => _ActivitiesDetailsScreenState();
}

class _ActivitiesDetailsScreenState extends State<ActivitiesDetailsScreen> {
  int _selectedIndex = 1; // Inicializa el índice en "Home" (1)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        _showInfoModal(context);
        break;
      case 1:
        Navigator.pushNamed(context, '/home'); // Navegar a Home
        break;
      case 2:
        Navigator.pushNamed(context, '/user_info'); // Navegar a la información del usuario
        break;
    }
  }

  void _showInfoModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Información'),
          content: const Text('Esta es una aplicación de gestión de actividades.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
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
        title: const Text('Detalles de Actividades'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
              'Número total: ${controller.totalActivities}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Actividades Booleanas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () => showAddBooleanActivityDialog(context, controller),
                      child: const Text('Añadir'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.booleanActivities.length,
                itemBuilder: (context, index) {
                  final activity = controller.booleanActivities[index];
                  final activityName = activity.keys.first;
                  final isChecked = activity.values.first;
                  return ListTile(
                    title: Text(activityName),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            controller.toggleBooleanActivity(index);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            controller.removeBooleanActivity(index);
                          },
                        ),
                      ],
                    ),
                  );
                },
              )),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Actividades Cuantitativas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () => showAddQuantitativeActivityDialog(context, controller),
                      child: const Text('Añadir'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.quantitativeActivities.length,
                itemBuilder: (context, index) {
                  final activity = controller.quantitativeActivities[index];
                  final activityName = activity.keys.first;
                  final initialCount = activity[activityName]!['initial'];
                  final currentCount = activity[activityName]!['current'];
                  return ListTile(
                    title: Text(
                      '$activityName: $currentCount (Esperado: $initialCount veces)',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, color: Colors.blue),
                          onPressed: () {
                            controller.decrementQuantitativeActivity(index);
                          },
                        ),
                        Text('$currentCount'),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.blue),
                          onPressed: () {
                            controller.incrementQuantitativeActivity(index);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            controller.removeQuantitativeActivity(index);
                          },
                        ),
                      ],
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BarraNavegacion(
        selectedIndex: _selectedIndex, // El índice del ítem seleccionado
        onItemTapped: _onItemTapped, // Manejo de la selección
      ),
    );
  }
}
