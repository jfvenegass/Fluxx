import 'package:get/get.dart';
import '../backend/database/db_helper.dart';

class LoginController extends GetxController {
  var userName = ''.obs;
  var userEmail = ''.obs;
  var isRegistered = false.obs;

  // Registro de usuario
  Future<void> registerUser(String name, String email, String password) async {
    print("Intentando registrar usuario: Name: $name, Email: $email");
    try {
      // Verificar si el usuario ya existe
      final existingUser = await DBHelper.getUserByEmail(email);
      if (existingUser != null) {
        print("Error: El usuario ya está registrado.");
        isRegistered.value = false;
        return;
      }

      // Registrar usuario
      await DBHelper.insert('users', {
        'name': name,
        'email': email,
        'password': password, // Guardar la contraseña (opcionalmente, deberías encriptarla)
      });

      // Actualizar estado
      userName.value = name;
      userEmail.value = email;
      isRegistered.value = true;
      print("Usuario registrado con éxito.");
    } catch (e) {
      isRegistered.value = false;
      print("Excepción en registerUser: $e");
    }
  }

  // Validar Login
  Future<bool> validateLogin(String email, String password) async {
    print("Validando login para: Email: $email");
    try {
      // Buscar usuario por email
      final user = await DBHelper.getUserByEmail(email);
      if (user != null && user['password'] == password) {
        // Login exitoso
        userName.value = user['name'];
        userEmail.value = user['email'];
        print("Login exitoso para: ${user['name']}");
        return true;
      } else {
        print("Error: Email o contraseña incorrectos.");
        return false;
      }
    } catch (e) {
      print("Excepción en validateLogin: $e");
      return false;
    }
  }
}
