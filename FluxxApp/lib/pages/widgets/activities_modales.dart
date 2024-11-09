
import 'package:flutter/material.dart';
import 'package:app_movil/backend/database/db_helper.dart';

Future<void> showAddActivityDialog(BuildContext context, String type) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController countController = TextEditingController();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(type == 'boolean' ? 'Añadir Actividad Unica' : 'Añadir Actividad Repetible'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Nombre de la actividad'),
            ),
            if (type == 'quantitative')
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
            onPressed: () async {
              final String name = nameController.text.trim();
              if (name.isNotEmpty) {
                if (type == 'boolean') {
                  await DBHelper.insert('activities', {'title': name, 'description': 'Boolean'});
                } else {
                  final int? count = int.tryParse(countController.text.trim());
                  if (count != null) {
                    await DBHelper.insert('activities', {'title': name, 'description': 'Quantitative: $count'});
                  }
                }
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
