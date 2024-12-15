import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kopi_verse/service/config.dart';
import 'package:kopi_verse/service/storage.dart';

import '../model/product.dart';
import '../model/product_detail.dart';

class ProductService with ChangeNotifier {
  List<Product> _productList = [];
  ProductDetail _productDetail = ProductDetail(
    id: '',
    name: '',
    detail: '',
    price: 0,
    image: '',
  );
  bool _isLoading = false;

  List<Product> get productList => _productList;
  ProductDetail get productDetail => _productDetail;
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
      debugPrint('Error fetching product: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // get product by id
  Future<void> getProductById(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await Storage.take('auth_token');
      final response = await http.get(
        Uri.parse('${Config.productUrl}/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        _productDetail = ProductDetail.fromJson(responseData['data']);
      } else {
        debugPrint('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetching product: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // add product to cart by id
  Future<bool> addToCart(String id, int quantity) async {
    try {
      final token = await Storage.take('auth_token');
      final response = await http.post(
        Uri.parse(Config.cartUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'product_id': id,
          'quantity': quantity,
        }),
      );

      return response.statusCode == 201 ? true : false;
    } catch (error) {
      debugPrint('Error adding product to cart: $error');
      return false;
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

    _productList =
        _productList.where((product) => product.category == category).toList();
    _isLoading = false;
    notifyListeners();
  }

  // add product

  // update product
}
