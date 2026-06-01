import 'package:flutter/material.dart';

class FavoriteKost {
  final String nama;
  final String lokasi;
  final String harga;
  final String tipe;
  final String foto;
  final String rating;
  final String fasilitas;
  final String ukuranKamar;
  final String lokasiLengkap;
  final List<String> fasilitasKamar;
  final List<Map<String, String>> tempatTerdekat;

  const FavoriteKost({
    required this.nama,
    required this.lokasi,
    required this.harga,
    required this.tipe,
    required this.foto,
    required this.rating,
    required this.fasilitas,
    required this.ukuranKamar,
    required this.lokasiLengkap,
    required this.fasilitasKamar,
    required this.tempatTerdekat,
  });
}

class FavoritesProvider extends ChangeNotifier {
  final List<FavoriteKost> _favorites = [];

  List<FavoriteKost> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String nama) => _favorites.any((k) => k.nama == nama);

  void toggle(FavoriteKost kost) {
    if (isFavorite(kost.nama)) {
      _favorites.removeWhere((k) => k.nama == kost.nama);
    } else {
      _favorites.add(kost);
    }
    notifyListeners();
  }
}
