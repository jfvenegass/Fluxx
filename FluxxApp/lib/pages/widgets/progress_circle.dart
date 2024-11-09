
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProgressCircle extends StatelessWidget {
  final double progress;

  const ProgressCircle({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 100.0,
      lineWidth: 10.0,
      percent: progress.clamp(0.0, 1.0),
      center: Text(
        "${(progress * 100).toStringAsFixed(1)}%",
        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      progressColor: Colors.teal,
      backgroundColor: Colors.grey[300]!,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}
