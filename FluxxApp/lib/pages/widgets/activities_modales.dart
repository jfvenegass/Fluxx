import 'package:app_movil/controllers/activities_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showAddActivityDialog(BuildContext context, String type) {
  final controller = Get.find<ActivitiesController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController countController = TextEditingController();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(type == 'boolean' ? 'Añadir Actividad Única' : 'Añadir Actividad Repetible'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Nombre de la actividad'),
            ),
            if (type == 'quantitative') // Solo pedir la cantidad si es cuantitativa
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
              final title = nameController.text.trim();
              if (type == 'boolean') {
                controller.addBooleanActivity(title);
              } else {
                final initialCount = int.tryParse(countController.text) ?? 0;
                controller.addQuantitativeActivity(title, initialCount);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Añadir'),
          ),
        ],
      );
    },
  );
}
