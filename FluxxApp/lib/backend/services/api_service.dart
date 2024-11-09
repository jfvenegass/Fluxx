import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static const String baseUrl = "https://tu-backend.com/api";

  // Método para enviar una actividad al backend
  static Future<void> sendActivity(Map<String, dynamic> activity) async {
    final response = await http.post(
      Uri.parse('$baseUrl/activities'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(activity),
    );

    if (response.statusCode != 201) {
      throw Exception("Error al enviar la actividad");
    }
  }

  // Método para obtener actividades del backend
  static Future<List<Map<String, dynamic>>> fetchActivities() async {
    final response = await http.get(Uri.parse('$baseUrl/activities'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Error al obtener actividades");
    }
  }

  // Método para login
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Método para registrar un nuevo usuario
  static Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"name": name, "email": email, "password": password}),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
