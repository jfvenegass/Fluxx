import 'package:app_movil/pages/widgets/barra_navegacion.dart';
import 'package:app_movil/pages/widgets/info_modal.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});
  
  @override
  UserPageState createState() => UserPageState();

}

class UserPageState extends State<UserPage>{
  int selectedIndex = 1; // Controlador de navegación, 1 es Home

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        showInfoModal(context);
        break;
      case 1:
        Navigator.pushNamed(context, '/home'); // Navegar a Home
        break;
      case 2:
        // Ya estamos en User Info, no hace nada
        break;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(bottomNavigationBar: BarraNavegacion(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),);
  }
}