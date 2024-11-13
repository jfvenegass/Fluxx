import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_movil/controllers/login_controller.dart';
import 'package:app_movil/pages/home_page.dart';
import 'package:app_movil/pages/login.dart';
import 'package:app_movil/pages/widgets/barra_navegacion.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  final LoginController loginController = Get.find(); // Obtener controlador

  int selectedIndex = 2;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        showAddActivityModal(); // Muestra el modal para añadir actividad.
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 2:
        // Estamos en la página de usuario
        break;
    }
  }

  void showAddActivityModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir Actividad'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Actividades Cuantitativas'),
                onTap: () {
                  Navigator.of(context).pop(); // Cierra el diálogo actual
                },
              ),
              ListTile(
                title: const Text('Actividades Booleanas'),
                onTap: () {
                  Navigator.of(context).pop(); // Cierra el diálogo actual
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void logout(BuildContext context) {
    // Opcional: limpiar estados relacionados con el usuario si es necesario
    loginController.userName.value = '';
    loginController.userEmail.value = '';
    loginController.password.value = '';
    loginController.isRegistered.value = false;

    // Redirigir al LoginScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del Usuario'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Alineación vertical central
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/user_avatar.png'),
              ),
              const SizedBox(height: 20),
              Text(
                loginController.userName.value,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 20),
              Text(
                'Correo Electrónico:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 5),
              Text(
                loginController.userEmail.value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Text(
                'Hábitos recomendados:',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center, // Centrar el texto
              ),
              const SizedBox(height: 5),
              Text(
                'Desayunar: Sí\nBeber Agua: 8 vasos\nEjercicio: 120 minutos\nDormir: 8 horas',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center, // Centrar el texto
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  logout(context); // Llamada al método para cerrar sesión
                },
                child: const Text('Cerrar Sesión'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BarraNavegacion(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
        onAddButtonPressed: showAddActivityModal,
      ),
    );
  }
}
