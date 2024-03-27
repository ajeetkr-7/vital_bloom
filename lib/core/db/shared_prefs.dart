
// singleton class to manage the shared preferences

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  // private constructor
  SharedPrefs._internal(this._prefs);

  // shared pref instance
  final SharedPreferences _prefs;

  // initialize the shared preferences
  static Future<SharedPrefs> init() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefs._internal(prefs);
  }

  // get the value for the given key
  Object? getValue(String key) => _prefs.get(key);

  // set the value for the given key
  Future<bool> setValue(String key, dynamic value) async {
    if (value is String) {
      return _prefs.setString(key, value);
    } else if (value is int) {
      return _prefs.setInt(key, value);
    } else if (value is double) {
      return _prefs.setDouble(key, value);
    } else if (value is bool) {
      return _prefs.setBool(key, value);
    } else if (value is List<String>) {
      return _prefs.setStringList(key, value);
    } else {
      return false;
    }
  }

  // remove the value for the given key
  Future<bool> removeValue(String key) async {
    return _prefs.remove(key);
  }

  // clear all the values
  Future<bool> clear() async {
    return _prefs.clear();
  }
}