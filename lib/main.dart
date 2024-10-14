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
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF48C9B0), // Verde Menta Oscuro
          secondary: Color(0xFF64B5F6), // Azul Cielo Medio
          error: Color(0xFFD32F2F), // Rojo Oscuro
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.grey),
          headlineLarge: TextStyle(color: Color(0xFF48C9B0), fontWeight: FontWeight.bold),
          labelLarge: TextStyle(color: Colors.white),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF48C9B0), // Verde Menta Oscuro
          textTheme: ButtonTextTheme.primary,
        ),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF48C9B0), // Verde Menta Oscuro
        ),
      ),
      home: LoginScreen(), // Página inicial
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => const HomePage(), 
        '/user_info': (context) => const UserPage(), 
      },
    );
  }
}