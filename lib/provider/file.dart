import 'package:flutter/material.dart';

class FileProvider with ChangeNotifier {
  String _file = '';

  String get file => _file;

  void setFile(String file) {
    _file = file;
    notifyListeners();
  }
}
