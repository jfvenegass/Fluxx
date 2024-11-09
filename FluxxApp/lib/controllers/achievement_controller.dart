import 'package:get/get.dart';
import '../backend/database/db_helper.dart';

class AchievementController extends GetxController {
  var achievements = <String, bool>{}.obs;

  // Cargar logros desde la base de datos
  Future<void> loadAchievements() async {
    final data = await DBHelper.getAll('achievements');
    achievements.value = {
      for (var achievement in data) achievement['title']: achievement['unlocked'] == 1
    };
  }

  // Desbloquear un logro
  Future<void> unlockAchievement(String achievement) async {
    achievements[achievement] = true;
    await DBHelper.insert('achievements', {'title': achievement, 'unlocked': 1});
  }

  // Verificar si un logro está desbloqueado
  bool isAchievementUnlocked(String achievement) {
    return achievements[achievement] ?? false;
  }
}
