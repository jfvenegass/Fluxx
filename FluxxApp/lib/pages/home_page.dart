
import 'package:flutter/material.dart';
import '../backend/database/db_helper.dart';
import '../backend/services/sync_service.dart';
import '../backend/models/activity_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Activity> activities = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final data = await DBHelper.getAll('activities');
    setState(() {
      activities = data.map((e) => Activity.fromMap(e)).toList();
    });
  }

  Future<void> _syncActivities() async {
    await SyncService.syncLocalToBackend();
    await SyncService.syncBackendToLocal();
    _loadActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _syncActivities,
            child: const Text('Sync Activities'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(activities[index].title),
                  subtitle: Text(activities[index].description),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
