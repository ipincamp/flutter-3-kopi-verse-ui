import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/order.dart';
import '../model/orders.dart';
import '../service/config.dart';
import '../service/storage.dart';

class OrderProvider with ChangeNotifier {
  List<Orders> _orders = [];
  Order _order = Order(
    barcode: '',
    date: '',
    total: 0,
    status: '',
    notes: '',
    items: [],
  );

  String _errorMessage = '';
  String _successMessage = '';
  String _barcode = '';
  int _total = 0;
  bool _isLoading = false;

  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;
  List<Orders> get orders => [..._orders];
  Order get order => _order;
  String get barcode => _barcode;
  int get total => _total;
  bool get isLoading => _isLoading;

  set orders(List<Orders> value) {
    _orders = value;
    notifyListeners();
  }

  void resetOrder() {
    _order = Order(
      barcode: '',
      date: '',
      total: 0,
      status: '',
      notes: '',
      items: [],
    );
    _barcode = '';
    _total = 0;
    _errorMessage = '';
    _successMessage = '';
    notifyListeners();
  }

  set errorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  set successMessage(String value) {
    _successMessage = value;
    notifyListeners();
  }

  set barcode(String value) {
    _barcode = value;
    notifyListeners();
  }

  set total(int value) {
    _total = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Process order
  Future<bool> createOrder() async {
    _isLoading = true;
    notifyListeners();
    try {
      final authToken = await Storage.take('auth_token');
      final response = await http.post(
        Uri.parse(Config.orderUrl),
        headers: Config.headers(token: authToken),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _barcode = responseJson['data']['barcode'];
        _total = int.parse(responseJson['data']['total'].toString());
        _successMessage = responseJson['message'];
        _errorMessage = '';
        return true;
      } else {
        _errorMessage = responseJson['errors'] ?? 'Unknown error occurred';
        return false;
      }
    } catch (error) {
      _errorMessage = error.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get all orders
  Future<void> getAllOrders() async {
    _isLoading = true;
    notifyListeners();
    try {
      final authToken = await Storage.take('auth_token');
      final response = await http.get(
        Uri.parse(Config.orderUrl),
        headers: Config.headers(token: authToken),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _orders = (responseJson['data'] as List)
            .map((data) => Orders.fromJson(data))
            .toList();
        _successMessage = responseJson['message'];
        _errorMessage = '';
      } else {
        _errorMessage = responseJson['errors'] ?? 'Unknown error occurred';
      }
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get order by barcode
  Future<void> getOrderByBarcode(String barcode) async {
    _isLoading = true;
    notifyListeners();
    try {
      final authToken = await Storage.take('auth_token');
      final response = await http.get(
        Uri.parse('${Config.orderUrl}/$barcode'),
        headers: Config.headers(token: authToken),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _order = Order.fromJson(responseJson['data']);
        _successMessage = responseJson['message'];
        _errorMessage = '';
      } else {
        _errorMessage = responseJson['errors'] ?? 'Unknown error occurred';
      }
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update order by barcode
  Future<bool> updateOrderByBarcode(
    String barcode,
    String status,
    String? note,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final authToken = await Storage.take('auth_token');
      final response = await http.put(
        Uri.parse('${Config.orderUrl}/$barcode/status'),
        headers: Config.headers(token: authToken),
        body: jsonEncode(<String, String>{
          'status': status,
          'note': note ?? '',
        }),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _barcode = responseJson['data']['barcode'];
        _total = int.parse(responseJson['data']['total'].toString());
        _successMessage = responseJson['message'];
        _errorMessage = '';
        await getOrderByBarcode(_barcode);
        return true;
      } else {
        _errorMessage = responseJson['errors'] ?? 'Unknown error occurred';
        return false;
      }
    } catch (error) {
      _errorMessage = error.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
