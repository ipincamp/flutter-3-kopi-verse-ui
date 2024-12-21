import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../model/cart.dart';
import '../service/config.dart';
import '../service/storage.dart';

class CartProvider with ChangeNotifier {
  List<Cart> _carts = [];
  String _errorMessage = '';
  String _successMessage = '';
  bool _isLoading = false;

  List<Cart> get carts {
    return [..._carts];
  }

  String get errorMessage {
    return _errorMessage;
  }

  String get successMessage {
    return _successMessage;
  }

  bool get isLoading {
    return _isLoading;
  }

  set carts(List<Cart> value) {
    if (_carts != value) {
      _carts = value;
      notifyListeners();
    }
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
    notifyListeners();
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

  // Get cart items
  Future<void> getCartItems() async {
    isLoading = true;
    notifyListeners();
    try {
      final authToken = await Storage.take('auth_token');
      final response = await http.get(
        Uri.parse(Config.cartUrl),
        headers: Config.headers(token: authToken),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<Cart> loadedCarts = [];
        responseJson['data'].forEach((cartData) {
          loadedCarts.add(Cart.fromJson(cartData));
        });
        carts = loadedCarts;
        successMessage = responseJson['message'];
      } else {
        errorMessage = responseJson['errors'] ?? 'Unknown error occurred';
      }
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Update cart item
  Future<bool> updateCartItem(String itemId, int newQuantity) async {
    isLoading = true;
    notifyListeners();
    try {
      final authToken = await Storage.take('auth_token');
      final response = await http.put(
        Uri.parse(Config.cartUrl),
        headers: Config.headers(token: authToken),
        body: jsonEncode(<String, dynamic>{
          'item_id': itemId,
          'new_quantity': newQuantity,
        }),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<Cart> loadedCarts = [];
        responseJson['data'].forEach((cartData) {
          loadedCarts.add(Cart.fromJson(cartData));
        });
        carts = loadedCarts;
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
