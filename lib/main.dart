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

  // Inicializamos Firebase
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fluxx',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.teal[800]),
          titleLarge: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic, color: Colors.teal[600]),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.teal[900]),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.teal[700],
          titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.teal[600],
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[600],
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
      home: LoginScreen(), // Página inicial
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomePage(), 
        '/user_info': (context) => UserPage(), 
      },
    );
  }
}