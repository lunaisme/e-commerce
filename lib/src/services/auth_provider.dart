import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;
  Map<String, dynamic>? _userData;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  Map<String, dynamic>? get userData => _userData;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _isAuthenticated = _token != null;
    if (_isAuthenticated) {
      _userData = {
        'name': prefs.getString('user_name'),
        'email': prefs.getString('user_email'),
        // tambahkan data user lainnya
      };
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      // Implementasi login API
      // Jika berhasil:
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', 'your_token_here');
      await prefs.setString('user_name', 'User Name');
      await prefs.setString('user_email', email);

      _isAuthenticated = true;
      _token = 'your_token_here';
      _userData = {
        'name': 'User Name',
        'email': email,
      };

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      // Implementasi register API
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _isAuthenticated = false;
    _token = null;
    _userData = null;

    notifyListeners();
  }

  Future<void> updateUserData(Map<String, dynamic> newData) async {
    try {
      // Implementasi update user data API
      _userData = {...?_userData, ...newData};
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
