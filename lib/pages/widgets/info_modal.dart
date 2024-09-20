import 'package:flutter/material.dart';

void showInfoModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('¿Puntaje?'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Actividad cuantitativa: 1 Punto.'),
            Text('Actividad booleana: 3 Puntos.'),
            SizedBox(height: 20),
            Text('Premios:'),
            Text('25 puntos: Nuevo tema (Gradiente azul)'),
            Text('50 puntos: Nuevo tema (Gradiente naranja)'),
            // Continuar con más información de puntaje y recompensas
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cerrar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
