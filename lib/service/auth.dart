import 'dart:convert';

import 'package:http/http.dart' as http;

import './config.dart';
import './storage.dart';

class AuthService {
  // Register
  static Future<http.Response> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final response = await http.post(
      Uri.parse('${Config.authUrl}/register'),
      headers: Config.headers(),
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      }),
    );

    return response;
  }

  // Login
  static Future<http.Response> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('${Config.authUrl}/login'),
      headers: Config.headers(),
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    return response;
  }

  // Logout
  static Future<http.Response> logout() async {
    final authToken = await Storage.take('auth_token');
    final response = await http.post(
      Uri.parse('${Config.authUrl}/logout'),
      headers: Config.headers(token: authToken),
    );

    if (response.statusCode == 202) {
      await Storage.drop('auth_token');
      await Storage.drop('auth_role');
    }

    return response;
  }
}
