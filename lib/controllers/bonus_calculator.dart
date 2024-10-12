import 'daily_bonus.dart';

DailyBonus calculateDailyBonus(int streak) {
  int baseExperience = 10;
  int baseCoins = 5;

  int experiencePoints = baseExperience * streak;
  int virtualCoins = baseCoins * streak;

  return DailyBonus(
    streak: streak,
    experiencePoints: experiencePoints,
    virtualCoins: virtualCoins,
  );
}