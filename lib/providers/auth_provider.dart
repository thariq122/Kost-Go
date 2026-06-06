import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/user_model.dart';
import '../data/service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;
  Uint8List? _profileImageBytes;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  Uint8List? get profileImageBytes => _profileImageBytes;

  // Getter convenience (kompatibel dengan kode layar lama)
  String get userName => _currentUser?.nama ?? '';
  String get userEmail => _currentUser?.email ?? '';
  String get userPhone => _currentUser?.noHp ?? '';
  String get userRole => _currentUser?.role ?? '';
  int get userId => _currentUser?.id ?? 0;

  // ── INIT: restore session saat app dibuka ──────────────────────────────
  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    final nama = prefs.getString('user_nama');
    final email = prefs.getString('user_email');
    final noHp = prefs.getString('user_no_hp');
    final role = prefs.getString('user_role');

    if (id != null && role != null) {
      _currentUser = UserModel(
        id: id,
        nama: nama ?? '',
        email: email ?? '',
        noHp: noHp ?? '',
        role: role,
      );
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  // ── LOGIN ──────────────────────────────────────────────────────────────
  Future<bool> login({
    required String noHp,
    required String password,
    required String role,
  }) async {
    _setLoading(true);
    try {
      final user =
          await _authService.login(noHp: noHp, password: password, role: role);
      if (user != null) {
        await _saveSession(user);
        _currentUser = user;
        _isLoggedIn = true;
        _setLoading(false);
        return true;
      } else {
        _errorMessage = 'No HP atau password salah';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  // ── LOGIN PENCARI (dipanggil dari login_pencari_screen) ────────────────
  Future<bool> loginPencari(String noHp, String password) =>
      login(noHp: noHp, password: password, role: 'pencari');

  // ── LOGIN PEMILIK (dipanggil dari login_pemilik_screen) ────────────────
  Future<bool> loginPemilik(String noHp, String password) =>
      login(noHp: noHp, password: password, role: 'pemilik');

  // ── REGISTER PENCARI ───────────────────────────────────────────────────
  Future<bool> registerPencari({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final user = await _authService.registerPencari(
          nama: name, noHp: phone, email: email, password: password);
      if (user != null) {
        await _saveSession(user);
        _currentUser = user;
        _isLoggedIn = true;
        _setLoading(false);
        return true;
      } else {
        _errorMessage = 'Pendaftaran gagal. Email mungkin sudah digunakan.';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  // ── REGISTER PEMILIK ───────────────────────────────────────────────────
  Future<bool> registerPemilik({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final user = await _authService.registerPemilik(
          nama: name, noHp: phone, email: email, password: password);
      if (user != null) {
        await _saveSession(user);
        _currentUser = user;
        _isLoggedIn = true;
        _setLoading(false);
        return true;
      } else {
        _errorMessage = 'Pendaftaran gagal. Silakan coba lagi.';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  // ── UPDATE PROFIL ──────────────────────────────────────────────────────
  void updateProfile(String name, String email, String phone) {
    if (_currentUser == null) return;
    _currentUser = UserModel(
      id: _currentUser!.id,
      nama: name,
      email: email,
      noHp: phone,
      role: _currentUser!.role,
    );
    _saveSession(_currentUser!);
    notifyListeners();
  }

  void updateProfilePicture(Uint8List? bytes) {
    _profileImageBytes = bytes;
    notifyListeners();
  }

  // ── LOGOUT ─────────────────────────────────────────────────────────────
  Future<void> logout() async {
    await _authService.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _currentUser = null;
    _isLoggedIn = false;
    _profileImageBytes = null;
    notifyListeners();
  }

  // ── HELPERS ────────────────────────────────────────────────────────────
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> _saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', user.id);
    await prefs.setString('user_nama', user.nama);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_no_hp', user.noHp);
    await prefs.setString('user_role', user.role);
  }
}
