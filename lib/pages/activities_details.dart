import 'package:app_movil/controllers/activities_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivitiesDetailsScreen extends StatelessWidget {
  const ActivitiesDetailsScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final ActivitiesController controller = Get.find();
    

    void showAddBooleanActivityDialog() {
      final TextEditingController nameController = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Añadir Actividad Booleana'),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Nombre de la actividad'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final String activityName = nameController.text.trim();
                  if (activityName.isNotEmpty) {
                    controller.addBooleanActivity(activityName);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Añadir'),
              ),
            ],
          );
        },
      );
    }

    void showAddQuantitativeActivityDialog() {
      final TextEditingController nameController = TextEditingController();
      final TextEditingController countController = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Añadir Actividad Cuantitativa'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Nombre de la actividad'),
                ),
                TextField(
                  controller: countController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Cantidad esperada'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final String activityName = nameController.text.trim();
                  final int? initialCount = int.tryParse(countController.text.trim());
                  if (activityName.isNotEmpty && initialCount != null) {
                    controller.addQuantitativeActivity(activityName, initialCount);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Añadir'),
              ),
            ],
          );
        },
      );
    }

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
                      onPressed: showAddBooleanActivityDialog,
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
                      onPressed: showAddQuantitativeActivityDialog,
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
    );
  }
}
