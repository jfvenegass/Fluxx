// lib/controllers/daily_bonus.dart
class DailyBonus {
  int streak;
  int experiencePoints;
  int virtualCoins;
  bool doubled;

  DailyBonus({
    required this.streak,
    required this.experiencePoints,
    required this.virtualCoins,
    this.doubled = false,
  });

  void doubleRewards() {
    if (!doubled) {
      experiencePoints *= 2;
      virtualCoins *= 2;
      doubled = true;
    }
  }
}