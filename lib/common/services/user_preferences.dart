import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static UserStorage? _instance;
  final SharedPreferences _sharedPreferences;

  static Future<UserStorage> getInstance() async {
    if (_instance == null) {
      final sharedPreferences = await SharedPreferences.getInstance();
      _instance = UserStorage._(sharedPreferences);
    }
    return _instance!;
  }

  UserStorage._(SharedPreferences sharedPreferences)
      : _sharedPreferences = sharedPreferences;

  Future<String> getString(String key, [String? defValue]) async {
    return _sharedPreferences.getString(key) ?? defValue ?? "";
  }

  Future<bool> setString(String key, String value) async {
    return _sharedPreferences.setString(key, value);
  }
}
