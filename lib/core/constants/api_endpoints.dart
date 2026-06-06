import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class ApiEndpoints {
  /// Base URL otomatis sesuai platform:
  /// - Web (browser)         → localhost (sama mesin)
  /// - Android emulator      → 10.0.2.2  (alias localhost di host)
  /// - iOS simulator         → localhost
  /// - Device fisik Android/iOS → ganti [_deviceIp] dengan IP LAN kamu
  static const String _deviceIp =
      '192.168.1.100'; // ← ganti hanya jika test di HP fisik

  static String get baseUrl {
    if (kIsWeb) {
      // Flutter Web berjalan di browser yang sama mesin dengan XAMPP
      return 'http://localhost/kostgo_api';
    }
    // Platform hanya tersedia di non-web
    if (Platform.isAndroid) {
      // Android emulator mengakses host lewat 10.0.2.2
      return 'http://10.0.2.2/kostgo_api';
    }
    if (Platform.isIOS) {
      // iOS Simulator mengakses host langsung lewat localhost
      return 'http://localhost/kostgo_api';
    }
    // Fallback (desktop, device fisik, dll.)
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
