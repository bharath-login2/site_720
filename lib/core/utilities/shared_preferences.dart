// import 'package:shared_preferences/shared_preferences.dart';

// saveSharedPreference(String key, String value) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.setString(key, value);
// }

// getSharedPreference(String key) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString(key);
// }

// clearSharedPreference() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.clear();
// }

// Future<void> setSharedPreference(String key, String value) async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString(key, value);
// }

import 'package:shared_preferences/shared_preferences.dart';

saveSharedPreference(String key, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

getSharedPreference(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

/// LOGOUT CLEAR
clearSharedPreference() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  /// STORE PIN BEFORE CLEAR
  String? savedPin = prefs.getString("pin");

  /// CLEAR ALL DATA
  await prefs.clear();

  /// RESTORE PIN
  if (savedPin != null && savedPin.isNotEmpty) {
    await prefs.setString("pin", savedPin);
  }
}

Future<void> setSharedPreference(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}
