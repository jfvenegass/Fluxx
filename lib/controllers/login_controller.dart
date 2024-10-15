import 'package:get/get.dart';

class LoginController extends GetxController {
  var userName = ''.obs;
  var userEmail = ''.obs;
  var password = ''.obs;
  var isRegistered = false.obs; // Estado para verificar si se ha registrado
  
  // Método para registrar usuario
  void registerUser(String name, String email, String pass) {
    userName.value = name;
    userEmail.value = email;
    password.value = pass;
    isRegistered.value = true; // Cambia el estado a registrado
  }

  // Método para validar el login
  bool validateLogin(String email, String pass) {
    return isRegistered.value && userEmail.value == email && password.value == pass;
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
    if (pass.isEmpty || pass.length < 1) {
      return 'La contraseña debe contener al menos un carácter';
    }
    return null;
  }
}

