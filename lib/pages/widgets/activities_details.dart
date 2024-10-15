import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_movil/controllers/activities_controller.dart';

class ActivitiesDetails extends StatelessWidget {
  final ActivitiesController controller;

  const ActivitiesDetails({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        buildBooleanActivitiesSection(),
        const SizedBox(height: 16.0),
        buildQuantitativeActivitiesSection(),
      ],
    );
  }

  Widget buildBooleanActivitiesSection() {
    return Obx(() {
      return ExpansionTile(
        title: const Text(
          'Actividades Unicas',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          if (controller.booleanActivities.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No hay actividades unicas agregadas.'),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.booleanActivities.length,
              itemBuilder: (context, index) {
                final activity = controller.booleanActivities[index];
                final activityName = activity.keys.first;
                final isChecked = activity.values.first;

                return Column(
                  children: [
                    ListTile(
                      title: Text(activityName),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              controller.toggleBooleanActivity(index);
                            },
                            semanticLabel: 'Estado de la actividad: $activityName',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              controller.removeBooleanActivity(index);
                            },
                            tooltip: 'Eliminar actividad',
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
        ],
      );
    });
  }

  Widget buildQuantitativeActivitiesSection() {
    return Obx(() {
      return ExpansionTile(
        title: const Text(
          'Actividades Repetibles',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          if (controller.quantitativeActivities.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No hay actividades repetibles agregadas.'),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.quantitativeActivities.length,
              itemBuilder: (context, index) {
                final activity = controller.quantitativeActivities[index];
                final activityName = activity.keys.first;
                final initialCount = activity[activityName]!['initial'];
                final currentCount = activity[activityName]!['current'];

                return Column(
                  children: [
                    ListTile(
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
                            tooltip: 'Disminuir actividad',
                          ),
                          Text('$currentCount'),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.blue),
                            onPressed: () {
                              controller.incrementQuantitativeActivity(index);
                            },
                            tooltip: 'Aumentar actividad',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              controller.removeQuantitativeActivity(index);
                            },
                            tooltip: 'Eliminar actividad',
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
        ],
      );
    });
  }
}
