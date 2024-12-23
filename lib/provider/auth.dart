import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../model/user.dart';
import '../service/config.dart';
import '../service/storage.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuth = false;
  bool _isLoading = false;
  String _errorMessage = '';
  String _role = '';
  String _token = '';
  User _user = User(
    uniqueId: '',
    name: '',
    email: '',
    joinSince: '',
    role: '',
    image: '',
    allOrders: 0,
  );
  List<User> _users = [];

  User get user {
    return _user;
  }

  List<User> get users {
    return [..._users];
  }

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

  // Profile
  Future<void> profile() async {
    _isLoading = true;
    notifyListeners();
    try {
      final authToken = await Storage.take('auth_token');
      final response = await http.get(
        Uri.parse('${Config.authUrl}/me'),
        headers: Config.headers(token: authToken),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _user = User.fromJson(responseJson['data']);
        _role = _user.role;
        _isAuth = true;
        _errorMessage = '';
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
  }

  // Get all users
  Future<void> getUsers() async {
    try {
      // Set loading to true
      _isLoading = true;

      // Fetch users from the server
      final authToken = await Storage.take('auth_token');
      final response = await http.get(
        Uri.parse(Config.userUrl),
        headers: Config.headers(
          token: authToken,
        ),
      );
      final responseJson = jsonDecode(response.body);
      /*
      {
        success: true,
        message: Users fetched successfully,
        data: [
          {
            id: 9dcb45a7-d67d-4c9d-86ef-a58b9c97d70b,
            name: User Cashier,
            email: cashier@cshop.com,
            role: cashier,
            joined_at: 5 hours ago,
            image: picture.jpg
          },
          {
            id: 9dcb45a8-f624-41ed-b0e4-fdf68b26e477,
            name: User Customer,
            email: customer@cshop.com,
            role: customer,
            joined_at: 5 hours ago,
            image: picture.jpg
          }
        ],
        errors: null
      }
      */

      if (response.statusCode == 200) {
        // Set users
        _users = (responseJson['data'] as List)
            .map((user) => User.fromJson(user))
            .toList();
        _errorMessage = '';
      } else {
        _errorMessage = responseJson['errors'].toString();
      }

      // Set loading to false
      _isLoading = false;
    } catch (error) {
      // Set loading to false
      _isLoading = false;

      // Set error message
      errorMessage = error.toString();
    }
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
