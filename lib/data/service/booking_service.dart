import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_clients.dart';
import '../model/booking_model.dart';

class BookingService {
  static const Duration _timeout = Duration(seconds: 30);

  /// Kirim booking baru — support upload bukti transfer (XFile, cross-platform)
  Future<int?> createBooking({
    required int userId,
    required int kostId,
    required String namaPenyewa,
    required String noHp,
    required String tanggalMasuk,
    required int durasiBulan,
    required int totalHarga,
    required String metodeBayar,
    XFile? buktiTransfer,
    String? catatan,
  }) async {
    final fields = {
      'user_id': userId.toString(),
      'kost_id': kostId.toString(),
      'nama_penyewa': namaPenyewa,
      'no_hp': noHp,
      'tanggal_masuk': tanggalMasuk,
      'durasi_bulan': durasiBulan.toString(),
      'total_harga': totalHarga.toString(),
      'metode_bayar': metodeBayar,
      'catatan': catatan ?? '',
    };

    final uri = Uri.parse(ApiEndpoints.createBooking);
    final request = http.MultipartRequest('POST', uri);
    request.fields.addAll(fields);

    // Lampirkan bukti transfer kalau ada
    if (buktiTransfer != null) {
      final bytes = await buktiTransfer.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'bukti_transfer',
        bytes,
        filename: buktiTransfer.name,
      ));
    }

    final streamed = await request.send().timeout(_timeout);
    final response = await http.Response.fromStream(streamed);
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        decoded['status'] == 'success') {
      return (decoded['data'] as Map<String, dynamic>)['booking_id'] as int?;
    }
    throw Exception(decoded['message'] ?? 'Booking gagal');
  }

  /// Riwayat booking milik user (pencari)
  Future<List<BookingModel>> getUserBookings(int userId) async {
    final response = await ApiClient.get(
      ApiEndpoints.getUserBookings,
      queryParams: {'user_id': userId.toString()},
    );
    if (response['status'] == 'success') {
      return (response['data'] as List<dynamic>)
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Semua booking masuk ke kost milik pemilik
  Future<List<BookingModel>> getOwnerBookings(int pemilikId) async {
    final response = await ApiClient.get(
      ApiEndpoints.getOwnerBookings,
      queryParams: {'pemilik_id': pemilikId.toString()},
    );
    if (response['status'] == 'success') {
      return (response['data'] as List<dynamic>)
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Update status booking — pemilik terima/tolak
  Future<bool> updateStatus({
    required int bookingId,
    required int pemilikId,
    required String status,
  }) async {
    final response = await ApiClient.post(
      ApiEndpoints.updateBookingStatus,
      body: {
        'booking_id': bookingId,
        'pemilik_id': pemilikId,
        'status': status,
      },
    );
    return response['status'] == 'success';
  }
}
