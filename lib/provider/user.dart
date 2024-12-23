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
        _users = (responseJson['data'] as List)
            .map((user) => User.fromJson(user))
            .toList();
        _errorMessage = '';
      } else {
        _errorMessage = responseJson['errors'].toString();
      }

      // Set loading to false
      isLoading = false;
    } catch (error) {
      // Set loading to false
      isLoading = false;

      // Set error message
      errorMessage = error.toString();
    }
  }

  // Add new user
  Future<void> addUser(
    String role,
    String name,
    String email,
    String password,
  ) async {
    try {
      // Set loading to true
      isLoading = true;

      // Add user to the server

      // Set loading to false
      isLoading = false;
    } catch (error) {
      // Set loading to false
      isLoading = false;

      // Set error message
      errorMessage = error.toString();
    }
  }

  // Update cashier
  Future<void> updateUser(
    String role,
    String id,
    String name,
    String email,
  ) async {
    try {
      // Set loading to true
      isLoading = true;

      // Update user on the server

      // Set loading to false
      isLoading = false;
    } catch (error) {
      // Set loading to false
      isLoading = false;

      // Set error message
      errorMessage = error.toString();
    }
  }
}
