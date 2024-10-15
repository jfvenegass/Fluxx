import 'package:flutter/material.dart';
import 'package:app_movil/pages/home_page.dart';
import 'package:app_movil/pages/widgets/barra_navegacion.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center( // Usar Center para centrar el contenido
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/user_avatar.png'), // Imagen de perfil
              ),
              const SizedBox(height: 20),
              Text(
                'Nombre del Usuario',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center, // Centrar el texto
              ),
              const SizedBox(height: 20),
              Text(
                'Correo Electrónico:',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center, // Centrar el texto
              ),
              const SizedBox(height: 5),
              Text(
                'usuario@correo.com',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center, // Centrar el texto
              ),
              const SizedBox(height: 20),
              Text(
                'Hábitos Recomendados:',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center, // Centrar el texto
              ),
              const SizedBox(height: 5),
              Text(
                'Desayunar: Sí\nBeber Agua: 8 vasos\nEjercicio: 120 minutos\n Dormir: 8 horas',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center, // Centrar el texto
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,                      
                ),
                onPressed: () {
                  // Acción para editar perfil
                },
                child: const Text('Editar Perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
