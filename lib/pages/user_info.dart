import 'package:flutter/material.dart';
import 'package:app_movil/pages/home_page.dart';
import 'package:app_movil/pages/widgets/barra_navegacion.dart';
import 'package:app_movil/pages/widgets/activities_modales.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});
  
  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  int selectedIndex = 2; // Controlador de navegación, 2 es User Info

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
        ); // Navegar a Home reemplazando la vista actual.
        break;
      case 2:
        // Ya estamos en User Info, no hace nada.
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
                  // Llama a la función que abre el modal para agregar actividades cuantitativas.
                },
              ),
              ListTile(
                title: const Text('Actividades Booleanas'),
                onTap: () {
                  Navigator.of(context).pop(); // Cierra el diálogo actual
                  // Llama a la función que abre el modal para agregar actividades booleanas.
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del Usuario'),
        automaticallyImplyLeading: false, // Para que no aparezca la flecha de retroceso.
      ),
      bottomNavigationBar: BarraNavegacion(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
        onAddButtonPressed: showAddActivityModal,
      ),
      body: Center(
        child: const Text('Contenido de la información del usuario'),
      ),
    );
  }
}
