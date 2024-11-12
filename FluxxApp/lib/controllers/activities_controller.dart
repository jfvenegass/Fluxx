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

  // Cargar actividades desde la base de datos
  Future<void> loadActivities() async {
    final data = await DBHelper.getAll('activities');
    booleanActivities.value = data
        .where((activity) => activity['type'] == 'boolean')
        .map((activity) =>
            {activity['title'] as String: activity['status'] == 1})
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

  // Agregar actividad booleana (única)
  Future<void> addBooleanActivity(String title) async {
    if (!_activityExists(title)) {
      booleanActivities.add({title: false});
      await DBHelper.insert(
          'activities', {'title': title, 'type': 'boolean', 'status': 0});
    }
  }

  // Agregar actividad cuantitativa (repetible)
  Future<void> addQuantitativeActivity(String title, int initialCount) async {
    if (!_activityExists(title)) {
      quantitativeActivities.add({
        title: {'initial': initialCount, 'current': 0}
      });
      await DBHelper.insert('activities', {
        'title': title,
        'type': 'quantitative',
        'initial_count': initialCount,
        'current_count': 0
      });
    }
  }

  // Incrementar progreso de actividad cuantitativa
  Future<void> incrementQuantitativeActivity(String title) async {
    final index = quantitativeActivities
        .indexWhere((activity) => activity.keys.first == title);
    if (index != -1) {
      final activity = quantitativeActivities[index];
      final current = activity[title]!['current']! + 1;
      quantitativeActivities[index] = {
        title: {'initial': activity[title]!['initial']!, 'current': current}
      };
      await DBHelper.update(
        'activities',
        {'current_count': current},
        'title = ?',
        [title],
      );
    }
  }

  // Marcar actividad booleana como completada
  Future<void> toggleBooleanActivity(String title) async {
    final index = booleanActivities
        .indexWhere((activity) => activity.keys.first == title);
    if (index != -1) {
      booleanActivities[index] = {title: !booleanActivities[index][title]!};
      await DBHelper.update(
        'activities',
        {'status': booleanActivities[index][title]! ? 1 : 0},
        'title = ?',
        [title],
      );
    }
  }

  // Eliminar una actividad por título
  Future<void> deleteActivity(String title) async {
    booleanActivities.removeWhere((activity) => activity.keys.first == title);
    quantitativeActivities
        .removeWhere((activity) => activity.keys.first == title);

    // Eliminar la actividad de la base de datos
    await DBHelper.delete('activities', 'title = ?', [title]);
  }

  // Método privado para verificar si una actividad ya existe
  bool _activityExists(String title) {
    return booleanActivities.any((activity) => activity.keys.first == title) ||
        quantitativeActivities.any((activity) => activity.keys.first == title);
  }
}
