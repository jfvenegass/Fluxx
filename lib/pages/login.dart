import 'package:app_movil/pages/home_page.dart';
import 'package:app_movil/pages/signup.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido a FLUXX'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0), // Aumento del padding en todo el cuerpo
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Texto "Fluxx" en lugar del logo
              const Text(
                'Fluxx',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 40), // Espacio mayor entre el título y el primer TextField
              // TextField para email con borde y texto teal al seleccionarlo
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.teal), // Cambia el color del texto al escribir
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black), // Borde y texto normal
                  floatingLabelStyle: TextStyle(color: Colors.teal), // Cambia el color del label al estar enfocado
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0), // Borde normal
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2.0), // Borde al estar enfocado
                  ),
                ),
              ),
              const SizedBox(height: 24), // Mayor separación entre campos de texto
              // TextField para contraseña con estilo de borde siempre visible y texto teal al seleccionarlo
              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.teal), // Cambia el color del texto al escribir
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Colors.black), // Cambia color del label antes de enfocarse
                  floatingLabelStyle: TextStyle(color: Colors.teal), // Cambia el color del label al estar enfocado
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0), // Borde normal
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2.0), // Borde al estar enfocado
                  ),
                ),
              ),
              const SizedBox(height: 32), // Mayor separación antes del botón de inicio de sesión
              // Botón de inicio de sesión
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                child: const Text('Iniciar Sesión'),
              ),
              const SizedBox(height: 24), // Espacio adicional entre botón de inicio de sesión y enlace de registro
              // Enlace a registro
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                },
                child: const Text(
                  '¿No tienes cuenta? Regístrate aquí',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



