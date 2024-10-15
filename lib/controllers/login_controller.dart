import 'package:get/get.dart';

class LoginController extends GetxController {
  // Lista que simula una base de datos de usuarios registrados.
  final RxList<Map<String, String>> registeredUsers = <Map<String, String>>[].obs;

  // Verificar si el email es válido y si la contraseña cumple con los requisitos mínimos.
  String? validateEmail(String email) {
    if (!GetUtils.isEmail(email)) {
      return 'Email no válido';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'La contraseña no puede estar vacía';
    }
    return null;
  }

  // Función para registrar un usuario.
  bool registerUser(String email, String password) {
    if (validateEmail(email) == null && validatePassword(password) == null) {
      registeredUsers.add({'email': email, 'password': password});
      return true;
    }
    return false;
  }

  // Función para iniciar sesión.
  bool loginUser(String email, String password) {
    return registeredUsers.any(
      (user) => user['email'] == email && user['password'] == password,
    );
  }
}
