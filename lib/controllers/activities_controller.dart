import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivitiesController extends GetxController {
  // Constantes
  static const int pointsPerBooleanActivity = 3;

  // Lista de actividades booleanas (nombre y si está chequeada o no)
  final booleanActivities = [
    {'Ejercicio matutino': false},
    {'Meditación': false},
  ].obs;

  // Lista de actividades cuantitativas (nombre, valor inicial y actual)
  final quantitativeActivities = [
    {
      'Ejercicio de fuerza': {'initial': 5, 'current': 0}
    },
    {
      'Ciclismo': {'initial': 3, 'current': 0}
    },
  ].obs;

  // Puntajes
  var dailyPoints = 0.obs; // Puntos obtenidos en el día
  var totalPoints = 0.obs; // Puntos acumulados (inicialmente en 0)
  var streak = 0.obs; // Racha de días consecutivos

  @override
  void onInit() {
    super.onInit();
    _checkStreak();
  }

  // Método para contar el total de actividades (booleanas + cuantitativas)
  int get totalActivities =>
      booleanActivities.length + quantitativeActivities.length;

  // Método para contar cuántas actividades booleanas están chequeadas
  int get checkedBooleanActivities =>
      booleanActivities.where((activity) => activity.values.first).length;

  // Método para contar cuántas actividades cuantitativas se han hecho al menos una vez
  int get completedQuantitativeActivities => quantitativeActivities
      .where((activity) => activity.values.first['current']! > 0)
      .length;

  // Método para contar el número total de veces que se ha realizado una actividad cuantitativa
  int get totalQuantitativeActivityCount => quantitativeActivities
      .map((activity) => activity.values.first['current']!)
      .reduce((a, b) => a + b);

  // Añadir una nueva actividad booleana
  void addBooleanActivity(String activityName) {
    if (activityName.isNotEmpty && !booleanActivities.any((activity) => activity.keys.first == activityName)) {
      booleanActivities.add({activityName: false});
    }
  }

  // Eliminar una actividad booleana
  void removeBooleanActivity(int index) {
    if (booleanActivities[index].values.first) {
      dailyPoints.value -= pointsPerBooleanActivity;
    }
    booleanActivities.removeAt(index);
    _updatePoints();
  }

  // Alternar el estado de una actividad booleana (chequeada o no)
  void toggleBooleanActivity(int index) {
    final activity = booleanActivities[index];
    final key = activity.keys.first;
    booleanActivities[index] = {key: !activity[key]!};
    _updatePoints();
  }

  // Añadir una nueva actividad cuantitativa
  void addQuantitativeActivity(String activityName, int initialCount) {
    if (activityName.isNotEmpty && !quantitativeActivities.any((activity) => activity.keys.first == activityName)) {
      quantitativeActivities.add({
        activityName: {'initial': initialCount, 'current': 0}
      });
    }
  }

  // Eliminar una actividad cuantitativa
  void removeQuantitativeActivity(int index) {
    final activity = quantitativeActivities[index];
    final currentCount = activity.values.first['current']!;
    dailyPoints.value -= currentCount; // Restamos las veces que se ha realizado
    quantitativeActivities.removeAt(index);
    _updatePoints();
  }

  // Incrementar el valor actual de una actividad cuantitativa
  void incrementQuantitativeActivity(int index) {
    final activity = quantitativeActivities[index];
    final key = activity.keys.first;
    final currentCount = activity[key]!['current']!;
    quantitativeActivities[index] = {
      key: {'initial': activity[key]!['initial']!, 'current': currentCount + 1}
    };
    _updatePoints();
  }

  // Decrementar el valor actual de una actividad cuantitativa
  void decrementQuantitativeActivity(int index) {
    final activity = quantitativeActivities[index];
    final key = activity.keys.first;
    final currentCount = activity[key]!['current']!;
    if (currentCount > 0) {
      quantitativeActivities[index] = {
        key: {
          'initial': activity[key]!['initial']!,
          'current': currentCount - 1
        }
      };
    }
    _updatePoints();
  }

  // Actualizar los puntajes diarios
  void _updatePoints() {
    int newDailyPoints =
        (checkedBooleanActivities * pointsPerBooleanActivity) + totalQuantitativeActivityCount;
    dailyPoints.value = newDailyPoints;
  }

  // Añadir los puntos diarios al total (cuando decidas hacerlo)
  void addDailyPointsToTotal() {
    totalPoints.value += dailyPoints.value;
  }

  // Resetear puntos diarios (se puede usar al final del día)
  void resetDailyPoints() {
    dailyPoints.value = 0;
  }

  // Método para reiniciar las actividades booleanas (desmarcar todas)
  void resetBooleanActivities() {
    resetActivities(booleanActivities, false);
  }

  // Método para reiniciar las actividades cuantitativas (poner en 0 las actuales)
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
  }

  // Método para reiniciar las actividades
  void resetActivities<T>(RxList<Map<String, T>> activities, T defaultValue) {
    for (var i = 0; i < activities.length; i++) {
      final activity = activities[i];
      final key = activity.keys.first;
      activities[i] = {key: defaultValue};
    }
  }

  // Método para añadir los puntos diarios al total y reiniciar las actividades
  void addDailyPointsToTotalAndResetActivities(BuildContext context) {
    addDailyPointsToTotal();
    resetBooleanActivities();
    resetQuantitativeActivities();
    resetDailyPoints();
    incrementStreak(context);
    _saveLastActiveDate();
  }

  // Método para incrementar la racha
  void incrementStreak(BuildContext context) {
    streak.value += 1;
    if (streak.value % 10 == 0) {
      Future.delayed(Duration.zero, () => showCongratulationDialog(context));
    }
  }

  // Método para mostrar el diálogo de felicitación
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

  // Método para reiniciar la racha
  void resetStreak() {
    streak.value = 0;
  }

  // Método para guardar la última fecha activa
  Future<void> _saveLastActiveDate() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastActiveDate', DateTime.now().toIso8601String());
  }

  // Método para verificar la racha
  Future<void> _checkStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastActiveDateStr = prefs.getString('lastActiveDate');
    if (lastActiveDateStr != null) {
      final lastActiveDate = DateTime.parse(lastActiveDateStr);
      final now = DateTime.now();
      if (now.difference(lastActiveDate).inDays >= 1) {
        resetStreak();
      }
    }
  }
}