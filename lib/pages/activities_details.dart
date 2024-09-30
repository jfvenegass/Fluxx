import 'package:app_movil/controllers/activities_controller.dart';
import 'package:app_movil/pages/home_page.dart';
import 'package:app_movil/pages/user_info.dart';
import 'package:app_movil/pages/widgets/activities_modales.dart';
import 'package:app_movil/pages/widgets/info_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_movil/pages/widgets/barra_navegacion.dart';

class ActivitiesDetailsScreen extends StatefulWidget {
  const ActivitiesDetailsScreen({super.key});

  @override
  ActivitiesDetailsScreenState createState() => ActivitiesDetailsScreenState();
}

class ActivitiesDetailsScreenState extends State<ActivitiesDetailsScreen> {
  int selectedIndex = 1; // Inicializa el índice en "Home" (1)

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        showInfoModal(context);
        break;
      case 1:
        Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomePage()),
                  ); // Navegar a Home
        break;
      case 2:
        Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserPage()),
                  ); // Navegar a la información del usuario
        break;
    }
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
                      onPressed: () =>
                          showAddBooleanActivityDialog(context, controller),
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
                      onPressed: () => showAddQuantitativeActivityDialog(
                          context, controller),
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
                              icon:
                                  const Icon(Icons.remove, color: Colors.blue),
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
        selectedIndex: selectedIndex, // El índice del ítem seleccionado
        onItemTapped: onItemTapped, // Manejo de la selección
      ),
    );
  }
}
