import 'package:flutter/material.dart';

class ActivitiesSummary extends StatelessWidget {
  final int totalActivities;
  final VoidCallback onDetailsPressed;

  const ActivitiesSummary({
    super.key,
    required this.totalActivities,
    required this.onDetailsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actividades Totales',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '$totalActivities',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: onDetailsPressed,
            child: const Text('Detalles'),
          ),
        ],
      ),
    );
  }
}
