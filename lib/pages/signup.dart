import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_movil/controllers/login_controller.dart';
import 'package:app_movil/pages/login.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Obtenemos una instancia del controlador
  final LoginController loginController = Get.put(LoginController());

  SignUpScreen({super.key});

  void registerUser(BuildContext context) {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Usar el controlador para registrar al usuario.
    bool success = loginController.registerUser(email, password);

    if (success) {
      // Registro exitoso, redirigir al login.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso. Ahora puedes iniciar sesión.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      // Mostrar error si el registro falla.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrarse. Verifica los datos e inténtalo de nuevo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                controller: nameController,
                style: const TextStyle(color: Colors.teal),
                decoration: const InputDecoration(
                  labelText: 'Nombre',
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
                  registerUser(context);
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  '¿Ya tienes cuenta? Inicia sesión aquí',
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


