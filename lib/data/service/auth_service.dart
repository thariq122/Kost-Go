class AuthService {
  // 1. SIMULASI FUNGSI LOGIN PENCARI
  Future<Map<String, dynamic>?> loginPencari(
      String email, String password) async {
    // Beri jeda 1 detik seolah-olah sedang loading jaringan
    await Future.delayed(const Duration(seconds: 1));

    if (email.isNotEmpty && password.length >= 6) {
      return {
        'uid': 'user_123',
        'name': 'Anak Rantau Keren',
        'email': email,
        'role': 'pencari',
      };
    }
    return null; // Return null jika gagal
  }

  // 2. SIMULASI FUNGSI REGISTER PENCARI
  Future<Map<String, dynamic>?> registerPencari(
      String name, String phone, String email, String password) async {
    // Beri jeda 1 detik untuk loading jaringan simulasi
    await Future.delayed(const Duration(seconds: 1));

    // Validasi sederhana, jika email tidak kosong dan password cukup panjang
    if (email.isNotEmpty && password.length >= 8) {
      return {
        'uid': 'pencari_${DateTime.now().millisecondsSinceEpoch}',
        'name': name,
        'phone': phone,
        'email': email,
        'role': 'pencari',
      };
    }
    return null; // Return null jika gagal registrasi
  }

  // 3. SIMULASI FUNGSI REGISTER PEMILIK
  Future<Map<String, dynamic>?> registerPemilik(
      String name, String phone, String email, String password) async {
    // Beri jeda 1 detik untuk loading jaringan simulasi
    await Future.delayed(const Duration(seconds: 1));

    if (email.isNotEmpty && password.length >= 8) {
      return {
        'uid': 'pemilik_${DateTime.now().millisecondsSinceEpoch}',
        'name': name,
        'phone': phone,
        'email': email,
        'role': 'pemilik',
      };
    }
    return null; // Return null jika gagal registrasi
  }
}
