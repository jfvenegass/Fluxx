import 'package:get/get.dart';

class ActivitiesController extends GetxController {
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
    booleanActivities.add({activityName: false});
  }

  // Eliminar una actividad booleana
  void removeBooleanActivity(int index) {
    // Si la actividad estaba chequeada, restamos sus puntos antes de eliminarla
    final activity = booleanActivities[index];
    if (activity.values.first) {
      dailyPoints.value -= 3;
    }

    booleanActivities.removeAt(index);

    // Recalcular puntos
    _updatePoints();
  }

  // Alternar el estado de una actividad booleana (chequeada o no)
  void toggleBooleanActivity(int index) {
    final activity = booleanActivities[index];
    final key = activity.keys.first;
    booleanActivities[index] = {key: !activity[key]!};

    // Recalcular puntos
    _updatePoints();
  }

  // Añadir una nueva actividad cuantitativa
  void addQuantitativeActivity(String activityName, int initialCount) {
    quantitativeActivities.add({
      activityName: {'initial': initialCount, 'current': 0}
    });
  }

  // Eliminar una actividad cuantitativa
  void removeQuantitativeActivity(int index) {
    // Restar los puntos aportados por la actividad antes de eliminarla
    final activity = quantitativeActivities[index];
    final currentCount = activity.values.first['current']!;
    dailyPoints.value -= currentCount; // Restamos las veces que se ha realizado

    quantitativeActivities.removeAt(index);

    // Recalcular puntos
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

    // Recalcular puntos
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

    // Recalcular puntos
    _updatePoints();
  }

  // Actualizar los puntajes diarios
  void _updatePoints() {
    // Calcular los puntos diarios
    int newDailyPoints =
        (checkedBooleanActivities * 3) + totalQuantitativeActivityCount;
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
    for (var i = 0; i < booleanActivities.length; i++) {
      final activity = booleanActivities[i];
      final key = activity.keys.first;
      booleanActivities[i] = {key: false};
    }
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

  // Método para añadir los puntos diarios al total y reiniciar las actividades
  void addDailyPointsToTotalAndResetActivities() {
    // Añadir los puntos diarios al total
    addDailyPointsToTotal();

    // Resetear las actividades booleanas y cuantitativas
    resetBooleanActivities();
    resetQuantitativeActivities();

    // Resetear los puntos diarios
    resetDailyPoints();
  }
}
