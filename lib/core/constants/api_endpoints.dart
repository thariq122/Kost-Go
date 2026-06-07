import 'package:flutter/foundation.dart';

class ApiEndpoints {
  /// Ganti sesuai environment:
  /// - XAMPP  → http://localhost/kostgo_api
  /// - Laragon → http://localhost/kostgo_api  (sama, Laragon juga pakai htdocs root)
  static const String _webBaseUrl = 'http://localhost/kostgo_api';

  /// IP LAN komputer — ganti jika test di HP fisik
  static const String _deviceIp = '192.168.1.100';

  static String get baseUrl {
    if (kIsWeb) {
      // Flutter Web: pakai relative URL agar same-origin dengan XAMPP
      // Saat flutter run -d chrome (localhost:PORT), tetap pakai absolute
      // Saat di-serve dari XAMPP (localhost/kostgo_app), pakai relative
      final uri = Uri.base;
      if (uri.port == 80 || uri.port == 443 || uri.port == 0) {
        // Di-serve dari XAMPP — same origin, pakai absolute localhost
        return 'http://localhost/kostgo_api';
      }
      // Flutter dev server (port berbeda) — pakai localhost langsung
      return 'http://localhost/kostgo_api';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2/kostgo_api';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'http://localhost/kostgo_api';
    }
    return 'http://$_deviceIp/kostgo_api';
  }

  // ── Auth ─────────────────────────────────────────────────────────────
  static String get login => '$baseUrl/api/auth/login.php';
  static String get register => '$baseUrl/api/auth/register.php';
  static String get logout => '$baseUrl/api/auth/logout.php';

  // ── Kost ─────────────────────────────────────────────────────────────
  static String get getAllKost => '$baseUrl/api/kost/get_all.php';
  static String get getDetailKost => '$baseUrl/api/kost/get_detail.php';

  // ── Booking ───────────────────────────────────────────────────────────
  static String get createBooking => '$baseUrl/api/booking/create.php';
  static String get getUserBookings =>
      '$baseUrl/api/booking/get_user_bookings.php';
  static String get getOwnerBookings =>
      '$baseUrl/api/booking/get_owner_bookings.php';
  static String get updateBookingStatus =>
      '$baseUrl/api/booking/update_status.php';

  // ── User ──────────────────────────────────────────────────────────────
  static String get updateProfile => '$baseUrl/api/user/update_profile.php';
  static String get getNotifications =>
      '$baseUrl/api/user/get_notifications.php';
  static String get readAllNotifications =>
      '$baseUrl/api/user/read_all_notifications.php';
  static String get ownerStats => '$baseUrl/api/user/owner_stats.php';
}
