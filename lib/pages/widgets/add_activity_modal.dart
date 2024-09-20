import 'package:flutter/material.dart';

void showAddActivityModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Añadir Actividad'),
        content: const TextField(
          decoration: InputDecoration(hintText: 'Nombre'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Añadir'),
            onPressed: () {
              // Lógica para añadir actividad
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
