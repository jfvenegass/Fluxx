
import 'package:flutter/material.dart';
import 'package:app_movil/backend/database/db_helper.dart';

class ActivitiesDetails extends StatelessWidget {
  const ActivitiesDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DBHelper.getAll('activities'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final activities = snapshot.data as List<Map<String, dynamic>>;
          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                title: Text(activity['title']),
                subtitle: Text(activity['description']),
              );
            },
          );
        }
      },
    );
  }
}
