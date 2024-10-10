import 'package:flutter/material.dart';
import 'package:app_movil/controllers/daily_bonus.dart'; // Importa DailyBonus
import 'package:app_movil/controllers/user.dart';

void doubleDailyBonus(User user) {
  user.dailyBonus.doubleRewards();
}

void showDailyBonus(BuildContext context, DailyBonus dailyBonus) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('¡Bonificación Diaria!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Has recibido:'),
            Text('Puntos de experiencia: ${dailyBonus.experiencePoints}'),
            Text('Monedas virtuales: ${dailyBonus.virtualCoins}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Aceptar'),
          ),
        ],
      );
    },
  );
}

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
              doubleDailyBonus(user);
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