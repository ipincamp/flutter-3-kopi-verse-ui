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

  String errorMessage = '';
  String successMessage = '';
  String barcode = '';
  int total = 0;
  bool isLoading = false;

  String get getErrorMessage {
    return errorMessage;
  }

  String get getSuccessMessage {
    return successMessage;
  }

  List<Orders> get orders {
    return [..._orders];
  }

  Order get order {
    return _order;
  }

  String get getBarcode {
    return barcode;
  }

  int get getTotal {
    return total;
  }

  bool get getIsLoading {
    return isLoading;
  }

  set setErrorMessage(String value) {
    errorMessage = value;
    notifyListeners();
  }

  set setSuccessMessage(String value) {
    successMessage = value;
    notifyListeners();
  }

  set setBarcode(String value) {
    barcode = value;
    notifyListeners();
  }

  set setTotal(int value) {
    total = value;
    notifyListeners();
  }

  set setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Process order
  Future<bool> createOrder() async {
    isLoading = true;
    notifyListeners();
    try {
      final authToken = await Storage.take('auth_token');
      final response = await http.post(
        Uri.parse(Config.orderUrl),
        headers: Config.headers(token: authToken),
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 201) {
        barcode = responseJson['data']['barcode'];
        total = int.parse(responseJson['data']['total'].toString());
        successMessage = responseJson['message'];
        errorMessage = '';
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

  // Get all orders
  Future<void> getAllOrders() async {
    isLoading = true;
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
        successMessage = responseJson['message'];
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

  // Get order by barcode
  Future<void> getOrderByBarcode(String barcode) async {
    isLoading = true;
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
        successMessage = responseJson['message'];
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
