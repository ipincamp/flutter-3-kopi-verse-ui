import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kopi_verse/model/product.dart';
import 'package:kopi_verse/service/config.dart';
import 'package:kopi_verse/service/storage.dart';

class ProductService with ChangeNotifier {
  List<Product> _productList = [];
  bool _isLoading = false;

  List<Product> get productList => _productList;
  bool get isLoading => _isLoading;

  // get all products
  Future<void> getProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await Storage.take('auth_token');
      final response = await http.get(
        Uri.parse(Config.productUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['data'] is Map) {
          final Map<String, dynamic> data = responseData['data'];
          final List<dynamic> drinks = data['drinks'] ?? [];
          final List<dynamic> foods = data['foods'] ?? [];
          _productList = [
            ...drinks.map((item) => Product.fromJson(item)),
            ...foods.map((item) => Product.fromJson(item)),
          ];
        } else {
          debugPrint('Data is not a map');
        }
      } else {
        debugPrint('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetching barang: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // filter by category
  void filterByCategory(String category) async {
    await getProducts();

    if (category == 'all') {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _productList = _productList.where((product) => product.category == category).toList();
    _isLoading = false;
    notifyListeners();
  }

  // add product

  // update product
}

