import 'package:get/get.dart';
import '../data/database_helper.dart';

class AchievementController extends GetxController {
  var achievements = <String, bool>{}.obs;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    loadAchievements();
  }

  Future<void> loadAchievements() async {
    final data = await _dbHelper.getAchievements();
    achievements.assignAll(data as Map<String, bool>);
  }

  Future<void> unlockAchievement(String achievement) async {
    achievements[achievement] = true;
    await _dbHelper.insertAchievement(achievement);
  }

  bool isAchievementUnlocked(String achievement) {
    return achievements[achievement] ?? false;
  }
}
