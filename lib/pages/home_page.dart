import 'package:app_movil/pages/user_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_movil/pages/widgets/barra_navegacion.dart';
import 'package:app_movil/controllers/activities_controller.dart';
import 'package:app_movil/pages/widgets/activities_details.dart';
import 'package:app_movil/pages/widgets/activities_modales.dart';
import 'package:app_movil/pages/login.dart';
import 'package:app_movil/pages/widgets/progress_circle.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 1;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        showAddActivityModal();
        break;
      case 1:
        // Estamos en Home.
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserPage()),
        );
        break;
    }
  }

  void showAddActivityModal() {
    final ActivitiesController controller = Get.find();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir Actividad'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Actividades Repetibles'),
                onTap: () {
                  Navigator.of(context).pop();
                  showAddQuantitativeActivityDialog(context, controller);
                },
              ),
              ListTile(
                title: const Text('Actividades Únicas'),
                onTap: () {
                  Navigator.of(context).pop();
                  showAddBooleanActivityDialog(context, controller);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showConfirmationDialog(
      BuildContext context, ActivitiesController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Deseas añadir los puntos diarios al total?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo.
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo de confirmación
                controller.addDailyPointsToTotalAndResetActivities(context);
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
    final ActivitiesController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FLUXX'),
        automaticallyImplyLeading: false,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const UserPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreakWidget(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        showConfirmationDialog(context, controller);
                      },
                      child: const Text('Añadir'),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                ProgressCircle(), // Aquí va la barra de progreso circular
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
                      'Actividades Únicas realizadas: ${controller.checkedBooleanActivities}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                const SizedBox(height: 16.0),
                Obx(() => Text(
                      'Actividades Repetibles empezadas: ${controller.completedQuantitativeActivities}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
                      ],
                    )),
              ],
            ),
          ),
          Expanded(
            child: ActivitiesDetails(
              controller: controller,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BarraNavegacion(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
        onAddButtonPressed: showAddActivityModal,
      ),
    );
  }
}

class StreakWidget extends StatelessWidget {
  final controller = Get.find<ActivitiesController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          children: [
            const Icon(Icons.local_fire_department, color: Colors.red, size: 24),
            const SizedBox(width: 4.0),
            Text(
              '${controller.streak}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ));
  }
}
