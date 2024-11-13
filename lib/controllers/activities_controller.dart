import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ActivitiesController extends GetxController {
  static const int pointsPerBooleanActivity = 3;

  final booleanActivities = <Map<String, bool>>[].obs;
  final quantitativeActivities = <Map<String, Map<String, int>>>[].obs;

  var dailyPoints = 0.obs;
  var totalPoints = 0.obs;
  var streak = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(
      'booleanActivities',
      jsonEncode(booleanActivities.map((e) => e).toList()),
    );

    prefs.setString(
      'quantitativeActivities',
      jsonEncode(quantitativeActivities.map((e) => e).toList()),
    );

    prefs.setInt('dailyPoints', dailyPoints.value);
    prefs.setInt('totalPoints', totalPoints.value);
    prefs.setInt('streak', streak.value);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final booleanActivitiesString = prefs.getString('booleanActivities');
    if (booleanActivitiesString != null) {
      final List<dynamic> booleanList = jsonDecode(booleanActivitiesString);
      booleanActivities.assignAll(
        booleanList.map((e) => Map<String, bool>.from(e)).toList(),
      );
    }

    final quantitativeActivitiesString = prefs.getString('quantitativeActivities');
    if (quantitativeActivitiesString != null) {
      final List<dynamic> quantitativeList = jsonDecode(quantitativeActivitiesString);
      quantitativeActivities.assignAll(
        quantitativeList.map((e) => Map<String, Map<String, int>>.from(e)).toList(),
      );
    }

    dailyPoints.value = prefs.getInt('dailyPoints') ?? 0;
    totalPoints.value = prefs.getInt('totalPoints') ?? 0;
    streak.value = prefs.getInt('streak') ?? 0;
  }

  void toggleBooleanActivity(int index) {
    final activity = booleanActivities[index];
    final key = activity.keys.first;
    booleanActivities[index] = {key: !activity[key]!};
    _updatePoints();
  }

  void incrementQuantitativeActivity(int index) {
    final activity = quantitativeActivities[index];
    final key = activity.keys.first;
    final currentCount = activity[key]!['current']!;
    quantitativeActivities[index] = {
      key: {
        'initial': activity[key]!['initial']!,
        'current': currentCount + 1,
      }
    };
    _updatePoints();
  }

  void decrementQuantitativeActivity(int index) {
    final activity = quantitativeActivities[index];
    final key = activity.keys.first;
    final currentCount = activity[key]!['current']!;
    if (currentCount > 0) {
      quantitativeActivities[index] = {
        key: {
          'initial': activity[key]!['initial']!,
          'current': currentCount - 1,
        }
      };
      _updatePoints();
    }
  }

  void addBooleanActivity(String activityName) {
    if (activityName.isNotEmpty &&
        !booleanActivities.any((activity) => activity.keys.first == activityName)) {
      booleanActivities.add({activityName: false});
      _saveData();
    }
  }

  void addQuantitativeActivity(String activityName, int initialCount) {
    if (activityName.isNotEmpty &&
        !quantitativeActivities.any((activity) => activity.keys.first == activityName)) {
      quantitativeActivities.add({
        activityName: {'initial': initialCount, 'current': 0}
      });
      _saveData();
    }
  }

  void removeBooleanActivity(int index) {
    booleanActivities.removeAt(index);
    _updatePoints();
    _saveData();
  }

  void removeQuantitativeActivity(int index) {
    quantitativeActivities.removeAt(index);
    _updatePoints();
    _saveData();
  }

  void addDailyPointsToTotal() {
    totalPoints.value += dailyPoints.value;
  }

  void resetDailyPoints() {
    dailyPoints.value = 0;
    _saveData();
  }

  void addDailyPointsToTotalAndResetActivities(BuildContext context) {
    addDailyPointsToTotal();
    resetBooleanActivities();
    resetQuantitativeActivities();
    resetDailyPoints();
    incrementStreak(context);
    _saveData();
  }

  void resetBooleanActivities() {
    for (var i = 0; i < booleanActivities.length; i++) {
      final activity = booleanActivities[i];
      final key = activity.keys.first;
      booleanActivities[i] = {key: false};
    }
    _saveData();
  }

  void resetQuantitativeActivities() {
    for (var i = 0; i < quantitativeActivities.length; i++) {
      final activity = quantitativeActivities[i];
      final key = activity.keys.first;
      quantitativeActivities[i] = {
        key: {
          'initial': activity[key]!['initial']!,
          'current': 0,
        }
      };
    }
    _saveData();
  }

  int get totalActivities {
    return booleanActivities.length + quantitativeActivities.length;
  }

  int get checkedBooleanActivities {
    return booleanActivities.where((activity) => activity.values.first).length;
  }

  int get completedQuantitativeActivities {
    return quantitativeActivities
        .where((activity) => activity.values.first['current']! > 0)
        .length;
  }

  void _updatePoints() {
    dailyPoints.value =
        (checkedBooleanActivities * pointsPerBooleanActivity) +
        quantitativeActivities.fold(
          0,
          (sum, activity) => sum + activity.values.first['current']!,
        );
  }

  void incrementStreak(BuildContext context) {
    streak.value += 1;
    if (streak.value % 10 == 0) {
      Future.delayed(Duration.zero, () => showCongratulationDialog(context));
    }
  }

  void showCongratulationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Felicidades!'),
          content: Text('Has alcanzado una racha de ${streak.value} días.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
