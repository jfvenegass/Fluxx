import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_movil/controllers/user.dart';
import 'package:app_movil/colors.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('Información del Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ${user.name}',
              style: TextStyle(fontSize: 18, color: textColor),
            ),
            SizedBox(height: 8.0),
            Text(
              'Correo electrónico: ${user.email}',
              style: TextStyle(fontSize: 18, color: textColor),
            ),
            SizedBox(height: 8.0),
            Text(
              'Racha diaria: ${user.streak} días',
              style: TextStyle(fontSize: 18, color: textColor),
            ),
            SizedBox(height: 8.0),
            Text(
              'Puntos totales: ${user.totalPoints}',
              style: TextStyle(fontSize: 18, color: textColor),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de edición de perfil
              },
              child: Text('Editar Perfil'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                // Lógica para cerrar sesión
              },
              child: Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}