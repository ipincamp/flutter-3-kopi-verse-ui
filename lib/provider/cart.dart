import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../service/config.dart';
import '../service/storage.dart';

class CartProvider with ChangeNotifier {
  String _errorMessage = '';
  String _successMessage = '';
  bool _isLoading = false;

  String get errorMessage {
    return _errorMessage;
  }

  String get successMessage {
    return _successMessage;
  }

  bool get isLoading {
    return _isLoading;
  }

  set errorMessage(String value) {
    if (_errorMessage != value) {
      _errorMessage = value;
      notifyListeners();
    }
  }

  set successMessage(String value) {
    if (_successMessage != value) {
      _successMessage = value;
      notifyListeners();
    }
  }

  set isLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  // Add product to cart
  Future<bool> addToCart(String id, int quantity) async {
    isLoading = true;
    try {
      final authToken = await Storage.take('auth_token');
      final response = await http.post(
        Uri.parse(Config.cartUrl),
        headers: Config.headers(token: authToken),
        body: jsonEncode(<String, dynamic>{
          'product_id': id,
          'quantity': quantity,
        }),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 201) {
        successMessage = responseJson['message'];
        return true;
      } else {
        errorMessage = responseJson['errors'] ?? 'Unknown error occurred';
        return false;
      }
    } catch (error) {
      errorMessage = error.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
