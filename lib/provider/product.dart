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
  String _productId = '';
  String _productName = '';
  String _errorMessage = '';
  bool _isLoading = false;

  List<Products> get products => [..._products];
  Product get product => _product;
  String get productId => _productId;
  String get productName => _productName;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

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

  Future<void> getProducts() async {
    _setLoading(true);
    try {
      final authToken = await Storage.take('auth_token');
      final response = await http.get(
        Uri.parse(Config.productUrl),
        headers: Config.headers(token: authToken),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _products = (responseJson['data'] as List)
            .map((product) => Products.fromJson(product))
            .toList();
        _setErrorMessage('');
      } else {
        _setErrorMessage(responseJson['errors'] ?? 'Unknown error occurred');
      }
    } catch (error) {
      _setErrorMessage(error.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getProductById(String id) async {
    _setLoading(true);
    try {
      final authToken = await Storage.take('auth_token');
      final response = await http.get(
        Uri.parse('${Config.productUrl}/$id'),
        headers: Config.headers(token: authToken),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _product = Product.fromJson(responseJson['data']);
        _setErrorMessage('');
      } else {
        _setErrorMessage(responseJson['errors'] ?? 'Unknown error occurred');
      }
    } catch (error) {
      _setErrorMessage(error.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addProduct(
    String name,
    String detail,
    int price,
    String category,
  ) async {
    _setLoading(true);
    try {
      final authToken = await Storage.take('auth_token');
      final response = await http.post(
        Uri.parse(Config.productUrl),
        headers: Config.headers(token: authToken),
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'detail': detail,
          'price': price,
          'category': category,
        }),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _productId = responseJson['data']['id'];
        _productName = responseJson['data']['name'];
        _setErrorMessage('');
        return true;
      } else {
        _setErrorMessage(responseJson['errors'] ?? 'Unknown error occurred');
        return false;
      }
    } catch (error) {
      _setErrorMessage(error.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProduct(
    String id,
    String name,
    String detail,
    int price,
    String category,
  ) async {
    _setLoading(true);
    try {
      final authToken = await Storage.take('auth_token');
      final response = await http.put(
        Uri.parse('${Config.productUrl}/$id'),
        headers: Config.headers(token: authToken),
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'detail': detail,
          'price': price,
          'category': category,
        }),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _productId = responseJson['data']['id'];
        _productName = responseJson['data']['name'];
        _setErrorMessage('');
        return true;
      } else {
        _setErrorMessage(responseJson['errors'] ?? 'Unknown error occurred');
        return false;
      }
    } catch (error) {
      _setErrorMessage(error.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteProduct(String id) async {
    _setLoading(true);
    try {
      final authToken = await Storage.take('auth_token');
      final response = await http.delete(
        Uri.parse('${Config.productUrl}/$id'),
        headers: Config.headers(token: authToken),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _productId = '';
        _productName = '';
        _setErrorMessage('');
        return true;
      } else {
        _setErrorMessage(responseJson['errors'] ?? 'Unknown error occurred');
        return false;
      }
    } catch (error) {
      _setErrorMessage(error.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  void _setErrorMessage(String value) {
    if (_errorMessage != value) {
      _errorMessage = value;
      notifyListeners();
    }
  }
}
