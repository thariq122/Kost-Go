class OwnerActivityItem {
  final int id;
  final String namaPenyewa;
  final String namaKost;
  final String status;
  final String metodeBayar;
  final int totalHarga;
  final String createdAt;

  const OwnerActivityItem({
    required this.id,
    required this.namaPenyewa,
    required this.namaKost,
    required this.status,
    required this.metodeBayar,
    required this.totalHarga,
    required this.createdAt,
  });

  factory OwnerActivityItem.fromJson(Map<String, dynamic> j) =>
      OwnerActivityItem(
        id: j['id'] is int ? j['id'] : int.parse(j['id'].toString()),
        namaPenyewa: j['nama_penyewa'] ?? '',
        namaKost: j['nama_kost'] ?? '',
        status: j['status'] ?? 'pending',
        metodeBayar: j['metode_bayar'] ?? 'transfer',
        totalHarga: j['total_harga'] is int
            ? j['total_harga']
            : int.tryParse(j['total_harga'].toString()) ?? 0,
        createdAt: j['created_at'] ?? '',
      );

  String get metodeBayarLabel =>
      metodeBayar == 'tunai' ? 'Tunai' : 'Transfer Bank';
}

class OwnerStatsModel {
  final int pendapatanBulanIni;
  final int pendapatanBulanLalu;
  final int selisihPendapatan;
  final int pendingCount;
  final List<OwnerActivityItem> aktivitasTerbaru;

  const OwnerStatsModel({
    required this.pendapatanBulanIni,
    required this.pendapatanBulanLalu,
    required this.selisihPendapatan,
    required this.pendingCount,
    required this.aktivitasTerbaru,
  });

  factory OwnerStatsModel.fromJson(Map<String, dynamic> j) => OwnerStatsModel(
        pendapatanBulanIni: _i(j['pendapatan_bulan_ini']),
        pendapatanBulanLalu: _i(j['pendapatan_bulan_lalu']),
        selisihPendapatan: _i(j['selisih_pendapatan']),
        pendingCount: _i(j['pending_count']),
        aktivitasTerbaru: (j['aktivitas_terbaru'] as List<dynamic>? ?? [])
            .map((e) => OwnerActivityItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  static int _i(dynamic v) =>
      v is int ? v : int.tryParse(v?.toString() ?? '0') ?? 0;

  String get pendapatanFormatted => _formatSingkat(pendapatanBulanIni);

  String get selisihFormatted {
    final prefix = selisihPendapatan >= 0 ? '+' : '-';
    return '$prefix${_formatSingkat(selisihPendapatan.abs())} dari bulan lalu';
  }

  static String _formatSingkat(int v) {
    if (v >= 1000000) {
      final jt = v / 1000000;
      final s = jt % 1 == 0 ? jt.toInt().toString() : jt.toStringAsFixed(1);
      return 'Rp $s Jt';
    }
    if (v >= 1000) {
      final rb = v / 1000;
      final s = rb % 1 == 0 ? rb.toInt().toString() : rb.toStringAsFixed(0);
      return 'Rp ${s}rb';
    }
    return 'Rp $v';
  }
}
