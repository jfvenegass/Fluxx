import 'package:app_movil/controllers/activities_controller.dart';
import 'package:app_movil/pages/home_page.dart';
import 'package:app_movil/pages/login.dart';
import 'package:app_movil/pages/signup.dart';
import 'package:app_movil/pages/user_info.dart'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  // Inicializamos el controlador
  Get.put(ActivitiesController());

  //Inicializamos Firebase
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluxx',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(), // Página inicial
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) =>  const HomePage(), 
        '/user_info': (context) => const UserPage(), 
      },
    );
  }
}
