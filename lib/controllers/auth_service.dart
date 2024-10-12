import 'user_service.dart';
import 'user.dart';

void onUserLogin(User user) {
  updateDailyStreak(user);

  // Mostrar las recompensas diarias al usuario
  showDailyBonus(user.dailyBonus);

  // Ofrecer la opción de doblar las recompensas
  if (user.dailyBonus.doubled == false) {
    offerDoubleBonus(user);
  }
}