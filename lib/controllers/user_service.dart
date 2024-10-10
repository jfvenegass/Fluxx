import 'package:flutter/material.dart';
import 'package:app_movil/controllers/user.dart';

class UserService {
  void offerDoubleBonus(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¡Doble Bonificación!'),
          content: Text('¿Quieres doblar tus recompensas diarias?'),
          actions: [
            TextButton(
              onPressed: () {
                user.dailyBonus.doubleRewards();
                Navigator.of(context).pop();
              },
              child: Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}