import 'package:get/get.dart';
import '../data/database_helper.dart';
import 'package:flutter/material.dart';

class ActivitiesController extends GetxController {
  static const int pointsPerBooleanActivity = 3;

  final DatabaseHelper dbHelper = DatabaseHelper();

  final booleanActivities = <Map<String, bool>>[].obs;
  final quantitativeActivities = <Map<String, Map<String, int>>>[].obs;

  var dailyPoints = 0.obs;
  var totalPoints = 0.obs;
  var streak = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    // Cargar streak y puntos totales
    streak.value = await dbHelper.getStreak();
    totalPoints.value = await dbHelper.getTotalPoints();

    // Cargar actividades
    final booleanList = await dbHelper.getBooleanActivities();
    booleanActivities.assignAll(booleanList);

    final quantitativeList = await dbHelper.getQuantitativeActivities();
    quantitativeActivities.assignAll(quantitativeList);

    // Actualizar puntos diarios
    _updatePoints();
  }

  Future<void> saveData() async {
    // Guardar streak y puntos totales
    await dbHelper.saveStreak(streak.value);
    await dbHelper.saveTotalPoints(totalPoints.value);
  }

  // Métodos para actividades booleanas
  void toggleBooleanActivity(int index) {
    final activity = booleanActivities[index];
    final key = activity.keys.first;
    booleanActivities[index] = {key: !activity[key]!};
    dbHelper.updateBooleanActivity(key, booleanActivities[index][key]!);
    _updatePoints();
  }

  void addBooleanActivity(String activityName) {
    if (activityName.isNotEmpty &&
        !booleanActivities.any((activity) => activity.keys.first == activityName)) {
      booleanActivities.add({activityName: false});
      dbHelper.insertBooleanActivity({activityName: false});
      _updatePoints();
    }
  }

  void removeBooleanActivity(int index) {
    final activity = booleanActivities[index];
    final key = activity.keys.first;
    booleanActivities.removeAt(index);
    dbHelper.deleteBooleanActivity(key);
    _updatePoints();
  }

  // Métodos para actividades cuantitativas
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
    dbHelper.updateQuantitativeActivity(key, currentCount + 1);
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
      dbHelper.updateQuantitativeActivity(key, currentCount - 1);
      _updatePoints();
    }
  }

  void addQuantitativeActivity(String activityName, int initialCount) {
    if (activityName.isNotEmpty &&
        !quantitativeActivities.any((activity) => activity.keys.first == activityName)) {
      quantitativeActivities.add({
        activityName: {'initial': initialCount, 'current': 0}
      });
      dbHelper.insertQuantitativeActivity({
        activityName: {'initial': initialCount, 'current': 0}
      });
      _updatePoints();
    }
  }

  void removeQuantitativeActivity(int index) {
    final activity = quantitativeActivities[index];
    final key = activity.keys.first;
    quantitativeActivities.removeAt(index);
    dbHelper.deleteQuantitativeActivity(key);
    _updatePoints();
  }

  // Métodos para streak
  void incrementStreak(BuildContext context) {
    streak.value += 1;
    if (streak.value % 10 == 0) {
      showCongratulationDialog(context);
    }
    dbHelper.saveStreak(streak.value);
  }

  void showCongratulationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Felicidades!'),
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

  // Puntos totales y diarios
  void addDailyPointsToTotal() {
    totalPoints.value += dailyPoints.value;
    dbHelper.saveTotalPoints(totalPoints.value);
  }

  void resetDailyPoints() {
    dailyPoints.value = 0;
    _updatePoints();
  }

  void addDailyPointsToTotalAndResetActivities(BuildContext context) {
    addDailyPointsToTotal();
    resetBooleanActivities();
    resetQuantitativeActivities();
    resetDailyPoints();
    incrementStreak(context);
  }

  void resetBooleanActivities() {
    for (var i = 0; i < booleanActivities.length; i++) {
      final activity = booleanActivities[i];
      final key = activity.keys.first;
      booleanActivities[i] = {key: false};
      dbHelper.updateBooleanActivity(key, false);
    }
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
      dbHelper.updateQuantitativeActivity(key, 0);
    }
  }

  // Calcular actividades booleanas marcadas
  int get checkedBooleanActivities {
    return booleanActivities.where((activity) => activity.values.first).length;
  }

  // Calcular actividades totales
  int get totalActivities {
    return booleanActivities.length + quantitativeActivities.length;
  }

  // Calcular actividades cuantitativas completadas
  int get completedQuantitativeActivities {
    return quantitativeActivities
        .where((activity) => activity.values.first['current']! > 0)
        .length;
  }

  // Calcular puntos diarios
  void _updatePoints() {
    dailyPoints.value =
        (checkedBooleanActivities * pointsPerBooleanActivity) +
        quantitativeActivities.fold(
          0,
          (sum, activity) => sum + activity.values.first['current']!,
        );
  }
}



