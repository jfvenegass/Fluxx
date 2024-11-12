import 'package:get/get.dart';
import '../backend/database/db_helper.dart';

class AchievementController extends GetxController {
  var achievements = <String, bool>{}.obs;

  // Cargar logros desde la base de datos
  Future<void> loadAchievements() async {
    final data = await DBHelper.getAll('achievements');
    achievements.value = {
      for (var achievement in data) achievement['title']: achievement['unlocked'] == 1,
    };
  }

  // Desbloquear un logro
  Future<void> unlockAchievement(String achievement) async {
    if (!achievements.containsKey(achievement)) {
      // Si el logro no existe, agregarlo
      achievements[achievement] = true;
      await DBHelper.insert('achievements', {'title': achievement, 'unlocked': 1});
    } else if (!achievements[achievement]!) {
      // Si el logro existe pero está bloqueado, actualizarlo
      achievements[achievement] = true;
      await DBHelper.update(
        'achievements',
        {'unlocked': 1},
        'title = ?',
        [achievement],
      );
    }
  }

  // Verificar si un logro está desbloqueado
  bool isAchievementUnlocked(String achievement) {
    return achievements[achievement] ?? false;
  }

  // Eliminar un logro
  Future<void> deleteAchievement(String achievement) async {
    achievements.remove(achievement);
    await DBHelper.delete('achievements', 'title = ?', [achievement]);
  }

  // Bloquear un logro (opcional)
  Future<void> lockAchievement(String achievement) async {
    if (achievements.containsKey(achievement) && achievements[achievement]!) {
      achievements[achievement] = false;
      await DBHelper.update(
        'achievements',
        {'unlocked': 0},
        'title = ?',
        [achievement],
      );
    }
  }
}
