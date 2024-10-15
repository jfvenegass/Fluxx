import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_movil/controllers/login_controller.dart';
import 'package:app_movil/pages/home_page.dart';
import 'package:app_movil/pages/signup.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Instancia del controlador
  final LoginController loginController = Get.put(LoginController());

  LoginScreen({super.key});

  void loginUser(BuildContext context) {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Validar email y contraseña
    String? emailError = loginController.validateEmail(email);
    String? passwordError = loginController.validatePassword(password);

    if (emailError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailError)),
      );
      return;
    }

    if (passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(passwordError)),
      );
      return;
    }

    // Intentar iniciar sesión
    bool success = loginController.loginUser(email, password);
    if (success) {
      // Si el inicio de sesión es exitoso, redirigir a la página principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // Mostrar mensaje de error si el inicio de sesión falla
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email o contraseña incorrectos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido a FLUXX'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Fluxx',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.teal),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black),
                  floatingLabelStyle: TextStyle(color: Colors.teal),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.teal),
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Colors.black),
                  floatingLabelStyle: TextStyle(color: Colors.teal),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  loginUser(context);
                },
                child: const Text('Iniciar Sesión'),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                },
                child: const Text(
                  '¿No tienes cuenta? Regístrate aquí',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





