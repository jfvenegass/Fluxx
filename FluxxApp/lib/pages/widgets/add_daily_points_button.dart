
import 'package:flutter/material.dart';
import 'package:app_movil/backend/database/db_helper.dart';

class AddDailyPointsButton extends StatelessWidget {
  const AddDailyPointsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await DBHelper.insert('points', {'daily_points': 100}); // Simulating daily points addition
      },
      child: const Text('Añadir puntos diarios'),
    );
  }
}
