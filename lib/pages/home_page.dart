import 'package:app_movil/pages/widgets/info_modal.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/pages/widgets/barra_navegacion.dart'; 
import 'package:app_movil/controllers/activities_controller.dart';
import 'activities_details.dart';
import 'package:get/get.dart';
import 'package:app_movil/pages/widgets/puntos.dart';
import 'package:app_movil/controllers/user.dart'; // Importa el modelo de usuario
import 'package:app_movil/controllers/user_service.dart'; // Importa el servicio de usuario
import 'package:app_movil/pages/widgets/daily_bonus_screen.dart'; // Importa la pantalla de bonificación diaria
import 'package:app_movil/colors.dart'; // Importa los colores
import 'user_info_screen.dart'; // Importa la pantalla de información del usuario

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 1; // Controlador de navegación, 1 es Home

  @override
  void initState() {
    super.initState();
    final User user = Get.find(); // Obtén el usuario actual
    onUserLogin(user); // Actualiza la racha diaria del usuario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDailyBonus(context, user.dailyBonus); // Muestra las recompensas diarias
      if (!user.dailyBonus.doubled) {
        offerDoubleBonus(context, user); // Ofrece la opción de doblar las recompensas
      }
      showStreakModal(context, user.streak); // Muestra el modal de racha
    });
  }

  void onUserLogin(User user) {
    user.updateStreak(); // Actualiza la racha diaria del usuario
    updateDailyStreak(user); // Llama a la función para actualizar la racha diaria
  }

  void updateDailyStreak(User user) {
    // Aquí puedes añadir la lógica para actualizar la racha diaria del usuario
    // Por ejemplo, podrías guardar la racha en una base de datos o en preferencias compartidas
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        showInfoModal(context);
        break;
      case 1:
        // Ya estamos en Home, no hace nada
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserInfoScreen()),
        );
        break;
    }
  }

  void showStreakModal(BuildContext context, int streak) {
    if (streak % 10 == 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('¡Felicidades!'),
            content: Text('Llevas una racha de $streak días. ¡Sigue así!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tienes una racha de $streak días.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ActivitiesController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text('FLUXX'),
        automaticallyImplyLeading: false, // Esto desactiva la flecha de retroceso en el AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Fluxx',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16.0),
              Obx(() => Text(
                'Actividades totales: ${controller.totalActivities}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              )),
              const SizedBox(height: 16.0),
              Obx(() => Text(
                'Actividades booleanas chequeadas: ${controller.checkedBooleanActivities}',
                style: const TextStyle(
                  fontSize: 18,
                  color: secondaryTextColor,
                ),
              )),
              const SizedBox(height: 16.0),
              Obx(() => Text(
                'Actividades cuantitativas realizadas al menos una vez: ${controller.completedQuantitativeActivities}',
                style: const TextStyle(
                  fontSize: 18,
                  color: secondaryTextColor,
                ),
              )),
              const SizedBox(height: 16.0),
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Puntos diarios: ${controller.dailyPoints}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Puntos totales: ${controller.totalPoints}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      showConfirmationDialog(context, controller);
                    },
                    child: const Text('Añadir puntos diarios al total'),
                  ),
                ],
              )),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Navegar a ActivitiesDetailsScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ActivitiesDetailsScreen(),
                    ),
                  );
                },
                child: const Text('Detalles'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BarraNavegacion(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}