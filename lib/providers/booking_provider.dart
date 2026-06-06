import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../data/model/booking_model.dart';
import '../data/service/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final BookingService _service = BookingService();

  List<BookingModel> _userBookings = [];
  List<BookingModel> _ownerBookings = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BookingModel> get userBookings => _userBookings;
  List<BookingModel> get ownerBookings => _ownerBookings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get pendingCount =>
      _ownerBookings.where((b) => b.status == 'pending').length;

  // ── Pencari: ambil riwayat booking ────────────────────────────────────
  Future<void> fetchUserBookings(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _userBookings = await _service.getUserBookings(userId);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Pemilik: ambil semua booking masuk ────────────────────────────────
  Future<void> fetchOwnerBookings(int pemilikId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _ownerBookings = await _service.getOwnerBookings(pemilikId);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Submit booking baru ────────────────────────────────────────────────
  Future<bool> createBooking({
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final id = await _service.createBooking(
        userId: userId,
        kostId: kostId,
        namaPenyewa: namaPenyewa,
        noHp: noHp,
        tanggalMasuk: tanggalMasuk,
        durasiBulan: durasiBulan,
        totalHarga: totalHarga,
        metodeBayar: metodeBayar,
        buktiTransfer: buktiTransfer,
        catatan: catatan,
      );
      _isLoading = false;
      notifyListeners();
      return id != null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ── Pemilik: terima/tolak booking ─────────────────────────────────────
  Future<bool> updateStatus({
    required int bookingId,
    required int pemilikId,
    required String status,
  }) async {
    try {
      final ok = await _service.updateStatus(
        bookingId: bookingId,
        pemilikId: pemilikId,
        status: status,
      );
      if (ok) {
        // Update state lokal agar UI langsung reflect
        final idx = _ownerBookings.indexWhere((b) => b.id == bookingId);
        if (idx != -1) {
          final old = _ownerBookings[idx];
          _ownerBookings[idx] = BookingModel(
            id: old.id,
            kostId: old.kostId,
            namaKost: old.namaKost,
            fotoKost: old.fotoKost,
            lokasiKost: old.lokasiKost,
            namaPenyewa: old.namaPenyewa,
            noHpPenyewa: old.noHpPenyewa,
            tanggalMasuk: old.tanggalMasuk,
            durasiBulan: old.durasiBulan,
            totalHarga: old.totalHarga,
            metodeBayar: old.metodeBayar,
            buktiTransfer: old.buktiTransfer,
            catatan: old.catatan,
            status: status,
            createdAt: old.createdAt,
          );
          notifyListeners();
        }
      }
      return ok;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
