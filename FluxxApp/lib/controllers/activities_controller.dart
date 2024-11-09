import 'package:get/get.dart';
import '../backend/database/db_helper.dart';

class ActivitiesController extends GetxController {
  var booleanActivities = <Map<String, bool>>[].obs;
  var quantitativeActivities = <Map<String, Map<String, int>>>[].obs;
  var dailyPoints = 0.obs;
  var totalPoints = 0.obs;
  var streak = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadActivities();
  }

  Future<void> loadActivities() async {
    final data = await DBHelper.getAll('activities');
    booleanActivities.value = data
        .where((activity) => activity['type'] == 'boolean')
        .map((activity) => {activity['title'] as String: activity['status'] == 1})
        .toList();

    quantitativeActivities.value = data
        .where((activity) => activity['type'] == 'quantitative')
        .map((activity) => {
              activity['title'] as String: {
                'initial': activity['initial_count'] as int,
                'current': activity['current_count'] as int,
              }
            })
        .toList();
  }

  Future<void> addBooleanActivity(String title) async {
    if (!booleanActivities.any((activity) => activity.keys.first == title)) {
      booleanActivities.add({title: false});
      await DBHelper.insert('activities', {'title': title, 'type': 'boolean', 'status': 0});
    }
  }

  Future<void> addQuantitativeActivity(String title, int initialCount) async {
    if (!quantitativeActivities.any((activity) => activity.keys.first == title)) {
      quantitativeActivities.add({title: {'initial': initialCount, 'current': 0}});
      await DBHelper.insert('activities', {
        'title': title,
        'type': 'quantitative',
        'initial_count': initialCount,
        'current_count': 0
      });
    }
  }

  Future<void> incrementQuantitativeActivity(String title) async {
    final index = quantitativeActivities.indexWhere((activity) => activity.keys.first == title);
    if (index != -1) {
      final activity = quantitativeActivities[index];
      final current = activity[title]!['current']! + 1;
      quantitativeActivities[index] = {
        title: {'initial': activity[title]!['initial']!, 'current': current}
      };
      await DBHelper.insert('activities', {'title': title, 'current_count': current});
    }
  }
}
