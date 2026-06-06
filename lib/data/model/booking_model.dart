class BookingModel {
  final int id;
  final int kostId;
  final String namaKost;
  final String? fotoKost;
  final String? lokasiKost;
  final String namaPenyewa;
  final String noHpPenyewa;
  final String tanggalMasuk;
  final int durasiBulan;
  final int totalHarga;
  final String metodeBayar; // 'transfer' | 'tunai'
  final String? buktiTransfer;
  final String? catatan;
  final String status; // 'pending' | 'diterima' | 'ditolak'
  final String createdAt;

  const BookingModel({
    required this.id,
    required this.kostId,
    required this.namaKost,
    this.fotoKost,
    this.lokasiKost,
    required this.namaPenyewa,
    required this.noHpPenyewa,
    required this.tanggalMasuk,
    required this.durasiBulan,
    required this.totalHarga,
    required this.metodeBayar,
    this.buktiTransfer,
    this.catatan,
    required this.status,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        id: _parseInt(json['id']),
        kostId: _parseInt(json['kost_id']),
        namaKost: json['nama_kost'] ?? '',
        fotoKost: json['foto_kost'],
        lokasiKost: json['lokasi_kost'],
        namaPenyewa: json['nama_penyewa'] ?? '',
        noHpPenyewa: json['no_hp_penyewa'] ?? '',
        tanggalMasuk: json['tanggal_masuk'] ?? '',
        durasiBulan: _parseInt(json['durasi_bulan']),
        totalHarga: _parseInt(json['total_harga']),
        metodeBayar: json['metode_bayar'] ?? 'transfer',
        buktiTransfer: json['bukti_transfer'],
        catatan: json['catatan'],
        status: json['status'] ?? 'pending',
        createdAt: json['created_at'] ?? '',
      );

  static int _parseInt(dynamic v) =>
      v is int ? v : int.tryParse(v.toString()) ?? 0;

  String get statusLabel {
    switch (status) {
      case 'diterima':
        return 'Diterima';
      case 'ditolak':
        return 'Ditolak';
      default:
        return 'Menunggu';
    }
  }

  String get durasiText => '$durasiBulan Bulan';
}
