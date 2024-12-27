import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../model/user.dart';
import '../service/config.dart';
import '../service/storage.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<User> get users {
    return [..._users];
  }

  set users(List<User> value) {
    _users = value;
    notifyListeners();
  }

  bool get isLoading {
    return _isLoading;
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String get errorMessage {
    return _errorMessage;
  }

  set errorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  // Get current user
  Future<void> getCurrentUser() async {
    try {
      // Set loading to true
      isLoading = true;

      // Fetch current user from the server
      final authToken = await Storage.take('auth_token');
      final response = await http.get(
        Uri.parse('${Config.authUrl}/me'),
        headers: Config.headers(
          token: authToken,
        ),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Set current user
        final List<User> loadedUsers = [];
        for (var user in responseJson['data']) {
          loadedUsers.add(User.fromJson(user));
        }
        _users = loadedUsers;

        // Clear error message
        errorMessage = '';
      } else {
        errorMessage = responseJson['errors'].toString();
      }
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      // Set loading to false
      isLoading = false;
    }
  }

  // Get all users
  Future<void> getUsers() async {
    try {
      // Set loading to true
      isLoading = true;

      // Fetch users from the server
      final authToken = await Storage.take('auth_token');
      final response = await http.get(
        Uri.parse(Config.userUrl),
        headers: Config.headers(
          token: authToken,
        ),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Set users
        final List<User> loadedUsers = [];
        for (var user in responseJson['data']) {
          loadedUsers.add(User.fromJson(user));
        }
        _users = loadedUsers;

        // Clear error message
        errorMessage = '';
      } else {
        errorMessage = responseJson['errors'].toString();
      }
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      // Set loading to false
      isLoading = false;
    }
  }
}
