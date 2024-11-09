import 'package:flutter/material.dart';
import '../backend/database/db_helper.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  Future<Map<String, dynamic>> getUserInfo() async {
    final user = await DBHelper.getUserInfo();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final user = snapshot.data!;
            return Column(
              children: [
                Text('Name: ${user['name']}'),
                Text('Email: ${user['email']}'),
              ],
            );
          }
        },
      ),
    );
  }
}
