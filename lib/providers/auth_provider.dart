import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data'; // <-- Untuk kebutuhan foto profil multiplatform (Web/App)
import '../data/service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  String _userName = 'Rian Mahasiswa';
  String _userEmail = 'rian@student.com';
  String _userPhone = '089876543210';

  // State untuk foto profil (bytes)
  Uint8List? _profileImageBytes;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;

  // Getter foto profil
  Uint8List? get profileImageBytes => _profileImageBytes;

  // 1. FUNGSI LOGIN PENCARI
  Future<bool> loginPencari(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.loginPencari(email, password);
      if (result != null) {
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage =
            'Email tidak valid atau password kurang dari 6 karakter';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan jaringan: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 2. FUNGSI REGISTER PENCARI KOS
  Future<bool> registerPencari({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result =
          await _authService.registerPencari(name, phone, email, password);
      if (result != null) {
        _userName = name;
        _userEmail = email;
        _userPhone = phone;
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Pendaftaran gagal. Email mungkin sudah digunakan.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan jaringan: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 3. FUNGSI REGISTER PEMILIK KOS
  Future<bool> registerPemilik({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result =
          await _authService.registerPemilik(name, phone, email, password);
      if (result != null) {
        _userName = name;
        _userEmail = email;
        _userPhone = phone;
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Pendaftaran pemilik gagal. Silakan coba lagi.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan jaringan: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 4. FUNGSI UPDATE FOTO PROFIL
  void updateProfilePicture(Uint8List? imageBytes) {
    _profileImageBytes = imageBytes;
    notifyListeners();
  }

  // 5. FUNGSI UPDATE DATA PROFIL TEXT
  void updateProfile(String name, String email, String phone) {
    _userName = name;
    _userEmail = email;
    _userPhone = phone;
    notifyListeners();
  }

  // 6. FUNGSI LOGOUT
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('role');
    } catch (e) {
      debugPrint("Gagal menghapus session lokal: $e");
    }

    _isLoggedIn = false;
    notifyListeners();
  }
}
