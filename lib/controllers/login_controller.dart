import 'package:get/get.dart';
import '../data/database_helper.dart';

class LoginController extends GetxController {
  var userName = ''.obs;
  var userEmail = ''.obs;
  var password = ''.obs;
  var isRegistered = false.obs;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Método para registrar usuario
  Future<void> registerUser(String name, String email, String pass) async {
    final user = {
      'name': name,
      'email': email,
      'password': pass,
    };
    await _dbHelper.insertUser(user);
    userName.value = name;
    userEmail.value = email;
    password.value = pass;
    isRegistered.value = true;
  }

  // Método para validar el login
  Future<bool> validateLogin(String email, String pass) async {
    final user = await _dbHelper.getUserByEmail(email);
    if (user != null && user['password'] == pass) {
      userName.value = user['name'];
      userEmail.value = user['email'];
      password.value = user['password'];
      return true;
    }
    return false;
  }

  // Validar email
  String? validateEmail(String email) {
    if (!GetUtils.isEmail(email)) {
      return 'Por favor ingresa un email válido';
    }
    return null;
  }

  // Validar contraseña
  String? validatePassword(String pass) {
    if (pass.isEmpty || pass.isEmpty) {
      return 'La contraseña debe contener al menos un carácter';
    }
    return null;
  }
}
