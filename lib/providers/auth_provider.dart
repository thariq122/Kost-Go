import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  // Fungsi login tiruan
  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }
}
