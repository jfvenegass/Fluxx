import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_movil/pages/widgets/info_modal.dart';
import 'package:app_movil/pages/widgets/barra_navegacion.dart'; 
import 'package:app_movil/controllers/activities_controller.dart';
import 'package:app_movil/pages/widgets/puntos.dart';
import 'package:app_movil/pages/widgets/activities_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 1; // Controlador de navegación, 1 es Home

  void onItemTapped(int index) {
  setState(() {
    selectedIndex = index;
  });

  switch (index) {
    case 0:
      showInfoModal(context); // Muestra el modal de información
      break;
    case 1:
      // Estamos en Home, así que no necesitamos hacer nada especial aquí.
      break;
    case 2:
      Navigator.pushNamed(context, '/user_info'); // Navega a la pantalla de información del usuario.
      break;
  }
}

  @override
  Widget build(BuildContext context) {
    final ActivitiesController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FLUXX'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                            showConfirmationDialog(context, controller);
                          },
                          child: const Text('Añadir puntos diarios al total'),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 300, // Altura ajustable.
            child: ActivitiesDetails(
              controller: controller,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BarraNavegacion(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}
    
