import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static Future<SharedPreferences> get _instance async =>
      await SharedPreferences.getInstance();
  static late SharedPreferences _prefs;

  UserStorage._internal();

  static Future<SharedPreferences?> init() async {
    _prefs = await _instance;
    return _prefs;
  }

  static String getString(String key, [String? defValue]) {
    return _prefs.getString(key) ?? defValue ?? "";
  }

  static Future<bool> setString(String key, String value) async {
    SharedPreferences prefs = await _instance;
    return prefs.setString(key, value);
  }
}
