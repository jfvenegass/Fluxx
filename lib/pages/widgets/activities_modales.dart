import 'package:flutter/material.dart';
import 'package:app_movil/controllers/activities_controller.dart';

Future<void> showAddBooleanActivityDialog(BuildContext context, ActivitiesController controller) {
  final TextEditingController nameController = TextEditingController();

  return showDialog(
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

Future<void> showAddQuantitativeActivityDialog(BuildContext context, ActivitiesController controller) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController countController = TextEditingController();

  return showDialog(
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
