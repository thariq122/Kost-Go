class KostModel {
  final int id;
  final int pemilikId;
  final String nama;
  final String tipe;
  final int harga;
  final int? hargaCoret;
  final String lokasi;
  final String lokasiLengkap;
  final String? ukuranKamar;
  final String? fasilitas;
  final String? foto;
  final double rating;
  final int sisaKamar;
  final String? diskon;
  final double? latitude;
  final double? longitude;
  final String namaPemilik;
  final String hpPemilik;
  final List<String> fasilitasKamar;
  final List<Map<String, String>> tempatTerdekat;

  const KostModel({
    required this.id,
    required this.pemilikId,
    required this.nama,
    required this.tipe,
    required this.harga,
    this.hargaCoret,
    required this.lokasi,
    required this.lokasiLengkap,
    this.ukuranKamar,
    this.fasilitas,
    this.foto,
    required this.rating,
    required this.sisaKamar,
    this.diskon,
    this.latitude,
    this.longitude,
    required this.namaPemilik,
    required this.hpPemilik,
    required this.fasilitasKamar,
    required this.tempatTerdekat,
  });

  factory KostModel.fromJson(Map<String, dynamic> json) => KostModel(
        id: _parseInt(json['id']),
        pemilikId: _parseInt(json['pemilik_id'] ?? 0),
        nama: json['nama'] ?? '',
        tipe: json['tipe'] ?? 'Campur',
        harga: _parseInt(json['harga']),
        hargaCoret:
            json['harga_coret'] != null ? _parseInt(json['harga_coret']) : null,
        lokasi: json['lokasi'] ?? '',
        lokasiLengkap: json['lokasi_lengkap'] ?? '',
        ukuranKamar: json['ukuran_kamar'],
        fasilitas: json['fasilitas'],
        foto: json['foto'],
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        sisaKamar: _parseInt(json['sisa_kamar'] ?? 0),
        diskon: json['diskon'],
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        namaPemilik: json['nama_pemilik'] ?? '',
        hpPemilik: json['hp_pemilik'] ?? '',
        fasilitasKamar: (json['fasilitas_kamar'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toList(),
        tempatTerdekat: (json['tempat_terdekat'] as List<dynamic>? ?? [])
            .map((e) => Map<String, String>.from(e as Map))
            .toList(),
      );

  /// Format harga ke string rupiah: "Rp 950.000"
  String get hargaFormatted => _formatRupiah(harga);
  String? get hargaCoretFormatted =>
      hargaCoret != null ? _formatRupiah(hargaCoret!) : null;
  String get sisaKamarText => 'Sisa $sisaKamar Kamar';

  static int _parseInt(dynamic v) =>
      v is int ? v : int.tryParse(v.toString()) ?? 0;

  static String _formatRupiah(int nilai) {
    final s = nilai.toString();
    final buffer = StringBuffer('Rp ');
    final mod = s.length % 3;
    buffer.write(s.substring(0, mod == 0 ? 3 : mod));
    for (int i = mod == 0 ? 3 : mod; i < s.length; i += 3) {
      buffer.write('.${s.substring(i, i + 3)}');
    }
    return buffer.toString();
  }
}
