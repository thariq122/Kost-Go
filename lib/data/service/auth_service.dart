import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_clients.dart';
import '../model/user_model.dart';

class AuthService {
  /// Login — role: 'pencari' atau 'pemilik'
  Future<UserModel?> login({
    required String noHp,
    required String password,
    required String role,
  }) async {
    final response = await ApiClient.post(
      ApiEndpoints.login,
      body: {
        'no_hp': noHp,
        'password': password,
        'role': role,
      },
    );
    if (response['status'] == 'success') {
      return UserModel.fromJson(response['data'] as Map<String, dynamic>);
    }
    return null;
  }

  /// Register pencari
  Future<UserModel?> registerPencari({
    required String nama,
    required String noHp,
    required String email,
    required String password,
  }) async {
    final response = await ApiClient.post(
      ApiEndpoints.register,
      body: {
        'nama': nama,
        'no_hp': noHp,
        'email': email,
        'password': password,
        'role': 'pencari',
      },
    );
    if (response['status'] == 'success') {
      return UserModel.fromJson(response['data'] as Map<String, dynamic>);
    }
    return null;
  }

  /// Register pemilik
  Future<UserModel?> registerPemilik({
    required String nama,
    required String noHp,
    required String email,
    required String password,
  }) async {
    final response = await ApiClient.post(
      ApiEndpoints.register,
      body: {
        'nama': nama,
        'no_hp': noHp,
        'email': email,
        'password': password,
        'role': 'pemilik',
      },
    );
    if (response['status'] == 'success') {
      return UserModel.fromJson(response['data'] as Map<String, dynamic>);
    }
    return null;
  }

  /// Logout
  Future<void> logout() async {
    try {
      await ApiClient.post(ApiEndpoints.logout, body: {});
    } catch (_) {
      // Logout lokal tetap jalan meski server gagal
    }
  }
}
