import 'package:app_movil/controllers/daily_bonus.dart';

class User {
  String name;
  String email;
  DateTime lastLogin;
  int streak;
  int totalPoints;
  DailyBonus dailyBonus;
  bool hasPremiumSubscription;

  User({
    required this.name,
    required this.email,
    required this.lastLogin,
    required this.streak,
    required this.totalPoints,
    required this.dailyBonus,
    this.hasPremiumSubscription = false,
  });

  bool purchaseDoubleBonus() {
    // Implementa la lógica para la compra de doble bonificación
    return true;
  }

  void updateStreak() {
    DateTime now = DateTime.now();
    if (now.difference(lastLogin).inDays == 1) {
      streak += 1;
    } else if (now.difference(lastLogin).inDays > 1) {
      streak = 1;
    }
    lastLogin = now;
  }
}