import '../database/db_helper.dart';
import '../services/api_service.dart';

class SyncService {
  // Sincronizar actividades locales al backend
  static Future<void> syncLocalToBackend() async {
    final localActivities = await DBHelper.getAll('activities');
    for (var activity in localActivities) {
      await APIService.sendActivity(activity);
    }
  }

  // Sincronizar actividades del backend a la base de datos local
  static Future<void> syncBackendToLocal() async {
    final remoteActivities = await APIService.fetchActivities();
    for (var activity in remoteActivities) {
      await DBHelper.insert('activities', activity);
    }
  }
}
