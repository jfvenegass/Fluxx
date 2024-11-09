import 'package:get/get.dart';

class AchievementController extends GetxController {
  var achievements = <String, bool>{}.obs;

  void unlockAchievement(String achievement) {
    achievements[achievement] = true;
  }

  bool isAchievementUnlocked(String achievement) {
    return achievements[achievement] ?? false;
  }
}