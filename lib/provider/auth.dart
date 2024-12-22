import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../service/config.dart';
import '../service/storage.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuth = false;
  bool _isLoading = false;
  String _errorMessage = '';
  String _role = '';
  String _token = '';

  bool get isAuth {
    return _isAuth;
  }

  bool get isLoading {
    return _isLoading;
  }

  set isAuth(bool value) {
    _isAuth = value;
    notifyListeners();
  }

  String get errorMessage {
    return _errorMessage;
  }

  set errorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  String get role {
    return _role;
  }

  set role(String value) {
    _role = value;
    notifyListeners();
  }

  set setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String get token {
    return _token;
  }

  set token(String value) {
    _token = value;
    notifyListeners();
  }

  // Register
  Future<bool> register(
    String fullName,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    bool success = false;
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('${Config.authUrl}/register'),
        headers: Config.headers(),
        body: jsonEncode(
          <String, String>{
            'name': fullName,
            'email': email,
            'password': password,
            'password_confirmation': passwordConfirmation,
          },
        ),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final authToken = responseJson['data']['token'];
        final authRole = 'customer';

        await Storage.save('auth_token', authToken);
        await Storage.save('auth_role', authRole);
        await Storage.save('is_auth', '1'); // 1 = true, 0 = false

        _token = authToken;
        _role = authRole;
        _isAuth = true;
        _errorMessage = '';

        success = true;
      } else {
        _isAuth = false;
        _errorMessage = responseJson['errors'];
      }
    } catch (error) {
      _isAuth = false;
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }

  // Login
  Future<bool> login(
    String email,
    String password,
  ) async {
    bool success = false;
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('${Config.authUrl}/login'),
        headers: Config.headers(),
        body: jsonEncode(
          <String, String>{
            'email': email,
            'password': password,
          },
        ),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final authToken = responseJson['data']['token'];
        final authRole = responseJson['data']['role'];

        await Storage.save('auth_token', authToken);
        await Storage.save('auth_role', authRole);
        await Storage.save('is_auth', '1'); // 1 = true, 0 = false

        _token = authToken;
        _role = authRole;
        _isAuth = true;
        _errorMessage = '';

        success = true;
      } else {
        _isAuth = false;
        _errorMessage = responseJson['errors'];
      }
    } catch (error) {
      _isAuth = false;
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }

  // Logout
  Future<bool> logout() async {
    bool success = false;
    _isLoading = true;
    notifyListeners();
    try {
      final authToken = await Storage.take('auth_token');
      final response = await http.post(
        Uri.parse('${Config.authUrl}/logout'),
        headers: Config.headers(token: authToken),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 202) {
        await Storage.drop('auth_token');
        await Storage.drop('auth_role');
        await Storage.save('is_auth', '0'); // 1 = true, 0 = false

        _token = '';
        _role = '';
        _isAuth = false;
        _errorMessage = '';

        success = true;
      } else {
        _isAuth = false;
        _errorMessage = responseJson['errors'];
      }
    } catch (error) {
      _isAuth = false;
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }
}
