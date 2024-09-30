import 'package:app_movil/controllers/activities_controller.dart';
import 'package:app_movil/pages/home_page.dart';
import 'package:app_movil/pages/user_page.dart'; 
import 'package:app_movil/pages/activities_details.dart'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  // Inicializar el controlador
  Get.put(ActivitiesController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(), // Página inicial
      routes: {
        '/home': (context) => const HomePage(), 
        '/user_info': (context) => const UserInfoPage(), 
        '/activities_details': (context) => const ActivitiesDetailsScreen(), 
      },
    );
  }
}
