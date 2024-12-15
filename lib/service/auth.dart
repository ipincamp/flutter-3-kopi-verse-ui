import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kopi_verse/service/config.dart';
import 'package:kopi_verse/service/storage.dart';

class AuthService {
  static Map<String, String> _headers({String? token}) {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // login
  static Future login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${Config.authUrl}/login'),
      headers: _headers(),
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    return response;
  }

  // register
  static Future register(String name, String email, String password, String confirmPassword) async {
    final response = await http.post(
      Uri.parse('${Config.authUrl}/register'),
      headers: _headers(),
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      }),
    );

    return response;
  }

  // logout
  static Future logout() async {
    final token = await Storage.take('auth_token');
    final response = await http.post(
      Uri.parse('${Config.authUrl}/logout'),
      headers: _headers(token: token),
    );

    return response;
  }
}
