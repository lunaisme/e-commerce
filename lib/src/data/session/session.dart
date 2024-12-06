import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String KEY_LOGIN_STATE = "login_state";
  static const String KEY_USER_ID = "user_id";

  Future<void> saveLoginSession(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KEY_LOGIN_STATE, true);
    await prefs.setInt(KEY_USER_ID, userId);
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_LOGIN_STATE) ?? false;
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(KEY_USER_ID);
  }

  Future<void> clearSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
