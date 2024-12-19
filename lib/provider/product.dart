import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../model/product.dart';
import '../model/products.dart';
import '../service/config.dart';
import '../service/storage.dart';

class ProductProvider with ChangeNotifier {
  List<Products> _products = [];
  Product _product = Product(
    id: '',
    name: '',
    detail: '',
    price: 0,
    image: '',
    available: false,
  );
  String _errorMessage = '';
  bool _isLoading = false;

  List<Products> get products {
    return [..._products];
  }

  Product get product {
    return _product;
  }

  String get errorMessage {
    return _errorMessage;
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

  set isLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  // Get all products
  Future<void> getProducts() async {
    isLoading = true;
    notifyListeners();
    try {
      final authToken = await Storage.take('auth_token');
      final response = await http.get(
        Uri.parse(Config.productUrl),
        headers: Config.headers(token: authToken),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseJson['data'] != null) {
          _products = (responseJson['data'] as List)
              .map((product) => Products.fromJson(product))
              .toList();
        } else {
          _products = [];
        }
        errorMessage = '';
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

  // Get single product
  Future<void> getProductById(String id) async {
    isLoading = true;
    notifyListeners();
    try {
      final authToken = await Storage.take('auth_token');
      final response = await http.get(
        Uri.parse('${Config.productUrl}/$id'),
        headers: Config.headers(token: authToken),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseJson['data'] != null) {
          _product = Product.fromJson(responseJson['data']);
        } else {
          _product = Product(
            id: '',
            name: '',
            detail: '',
            price: 0,
            image: '',
            available: false,
          );
        }
        errorMessage = '';
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
}
