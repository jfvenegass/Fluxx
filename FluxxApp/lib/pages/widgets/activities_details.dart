import 'package:app_movil/backend/database/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/controllers/activities_controller.dart';
import 'package:get/get.dart';

class ActivitiesDetails extends StatelessWidget {
  const ActivitiesDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final activitiesController = Get.find<ActivitiesController>();

    return Obx(() {
      return FutureBuilder(
        future: DBHelper.getAll('activities'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final activities = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                final type = activity['type'];
                final title = activity['title'];
                final isQuantitative = type == 'quantitative';
                final currentCount = isQuantitative ? activity['current_count'] : null;
                final status = activity['status'] ?? 0;

                return ListTile(
                  title: Text(title),
                  subtitle: isQuantitative
                      ? Text('Cantidad completada: $currentCount')
                      : Text(status == 1 ? 'Completada' : 'Pendiente'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Ícono de eliminación (basura roja)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          activitiesController.deleteActivity(title);
                        },
                      ),
                      // Ícono de marcar como completada para actividades booleanas
                      if (!isQuantitative)
                        IconButton(
                          icon: Icon(
                            status == 1 ? Icons.check_box : Icons.check_box_outline_blank,
                            color: status == 1 ? Colors.green : null,
                          ),
                          onPressed: () {
                            activitiesController.toggleBooleanActivity(title);
                          },
                        ),
                      // Ícono de incrementar para actividades repetibles
                      if (isQuantitative)
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            activitiesController.incrementQuantitativeActivity(title);
                          },
                        ),
                    ],
                  ),
                );
              },
            );
          }
        },
      );
    });
  }
}
