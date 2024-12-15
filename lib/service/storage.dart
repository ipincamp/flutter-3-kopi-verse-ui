import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get _instance async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  // save
  static Future<void> save(String key, String value) async {
    final prefs = await _instance;
    prefs.setString(key, value);
  }

  // take
  static Future<String?> take(String key) async {
    final prefs = await _instance;
    return prefs.getString(key);
  }

  // drop
  static Future<void> drop(String key) async {
    final prefs = await _instance;
    prefs.remove(key);
  }
}
