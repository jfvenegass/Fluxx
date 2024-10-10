import 'package:app_movil/controllers/activities_controller.dart';
import 'package:app_movil/controllers/user.dart';
import 'package:app_movil/controllers/daily_bonus.dart';
import 'package:app_movil/pages/home_page.dart';
import 'package:app_movil/pages/activities_details.dart';
import 'package:app_movil/pages/login.dart';
import 'package:app_movil/pages/signup.dart';
import 'package:app_movil/pages/user_info_screen.dart'; // Asegúrate de importar el archivo correcto
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'colors.dart'; // Importa los colores

void main() async {
  // Inicializamos el controlador
  Get.put(ActivitiesController());

  // Inicializamos el controlador de usuario
  Get.put(User(
    name: 'John Doe', // Añade el nombre del usuario
    email: 'john.doe@example.com', // Añade el correo electrónico del usuario
    lastLogin: DateTime.now(),
    streak: 0,
    totalPoints: 0, // Añade los puntos totales del usuario
    dailyBonus: DailyBonus(streak: 0, experiencePoints: 0, virtualCoins: 0),
  ));

  // Inicializamos Firebase
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fluxx',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor),
        scaffoldBackgroundColor: backgroundColor,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: textColor),
          bodyMedium: TextStyle(color: secondaryTextColor),
        ),
        appBarTheme: AppBarTheme(
          color: primaryColor,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: accentColor,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: LoginScreen(), // Página inicial
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => const HomePage(), 
        '/user_info': (context) => const UserInfoScreen(), // Asegúrate de usar la clase correcta
        '/activities_details': (context) => const ActivitiesDetailsScreen(), 
      },
    );
  }
}