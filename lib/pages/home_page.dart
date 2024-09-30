import 'package:flutter/material.dart';
import 'package:app_movil/pages/widgets/barra_navegacion.dart'; 
import 'package:app_movil/controllers/activities_controller.dart';
import 'activities_details.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 1; // Controlador de navegación, 1 es Home

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        _showInfoModal(context);
        break;
      case 1:
        // Ya estamos en Home, no hace nada
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserInfoPage()),
        );
        break;
    }
  }

  void _showInfoModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Información'),
          content: const Text('Esta es una aplicación de gestión de actividades.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, ActivitiesController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Deseas añadir los puntos diarios al total y reiniciar las actividades?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.addDailyPointsToTotalAndResetActivities(); // Añadir puntos al total
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ActivitiesController controller = Get.find(); // Asegúrate de que el controlador está inicializado

    return Scaffold(
      appBar: AppBar(
        title: const Text('FLUXX'),
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
                ),
              ),
              const SizedBox(height: 16.0),
              Obx(() => Text(
                    'Actividades totales: ${controller.totalActivities}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              const SizedBox(height: 16.0),
              Obx(() => Text(
                    'Actividades booleanas chequeadas: ${controller.checkedBooleanActivities}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  )),
              const SizedBox(height: 16.0),
              Obx(() => Text(
                    'Actividades cuantitativas realizadas al menos una vez: ${controller.completedQuantitativeActivities}',
                    style: const TextStyle(
                      fontSize: 18,
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
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Puntos totales: ${controller.totalPoints}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          _showConfirmationDialog(context, controller); // Mostrar el diálogo de confirmación
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
                        builder: (context) => const ActivitiesDetailsScreen()),
                  );
                },
                child: const Text('Detalles'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BarraNavegacion(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}


class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del Usuario'),
      ),
      body: const Center(
        child: Text(
          'Vista de información del usuario',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
