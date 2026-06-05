import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'booking_screen.dart';
import 'ui_helpers.dart';

class DetailKostScreen extends StatefulWidget {
  final String nama;
  final String harga;
  final String tipe;
  final String foto;
  final String ukuranKamar;
  final String lokasiLengkap;
  final List<String> fasilitasKamar;
  final List<Map<String, String>> tempatTerdekat;
  final String rating;
  final String fasilitas;

  const DetailKostScreen({
    super.key,
    required this.nama,
    required this.harga,
    required this.tipe,
    required this.foto,
    required this.ukuranKamar,
    required this.lokasiLengkap,
    required this.fasilitasKamar,
    required this.tempatTerdekat,
    this.rating = '4.8',
    this.fasilitas = '',
  });

  @override
  State<DetailKostScreen> createState() => _DetailKostScreenState();
}

class _DetailKostScreenState extends State<DetailKostScreen> {
  void _openBooking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingScreen(
          namaKost: widget.nama,
          harga: widget.harga,
          tipe: widget.tipe,
          foto: widget.foto,
          lokasi: widget.lokasiLengkap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 320,
                      width: double.infinity,
                      decoration: const BoxDecoration(color: kCardBg),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/${widget.foto}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.broken_image_outlined,
                                    color: Colors.white24, size: 60),
                              );
                            },
                          ),
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    kScaffoldBg.withValues(alpha: 0.6),
                                    Colors.transparent,
                                    kScaffoldBg,
                                  ],
                                  stops: const [0.0, 0.4, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 20,
                      right: 20,
                      child: Row(
                        children: [
                          buildGlassContainer(
                            radius: 20,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tipe Kos Dinamis
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xff14b8a6)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.tipe,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color: const Color(0xff14b8a6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Nama Kos Dinamis
                      Text(
                        widget.nama,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      // Rating & Status Sisa Kamar
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Color(0xff14b8a6), size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '4.8 (24 Ulasan)',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '• Sisa 2 Kamar',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: Colors.redAccent,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.white10),

                      // --- 1. SPESIFIKASI TIPE KAMAR (DINAMIS) ---
                      _buildSectionHeader(context, 'Spesifikasi tipe kamar'),
                      _buildInfoRow(context, Icons.crop_landscape_rounded,
                          widget.ukuranKamar),
                      _buildInfoRow(context, Icons.flash_off_rounded,
                          'Tidak termasuk listrik'),
                      const Divider(color: Colors.white10, height: 32),

                      // --- 2. FASILITAS KAMAR (DINAMIS MENGGUNAKAN LOOPING) ---
                      _buildSectionHeader(context, 'Fasilitas Kamar'),
                      Column(
                        children: widget.fasilitasKamar.map((fasilitas) {
                          return _buildInfoRow(context,
                              Icons.check_circle_outline_rounded, fasilitas);
                        }).toList(),
                      ),
                      _buildTextButton(
                          context, 'Lihat semua fasilitas kamar tipe ini'),
                      const Divider(color: Colors.white10, height: 32),

                      // --- 3. FASILITAS KAMAR MANDI ---
                      _buildSectionHeader(context, 'Fasilitas kamar mandi'),
                      _buildInfoRow(context, Icons.bathtub_outlined,
                          'Kamar Mandi Dalam (Shower)'),
                      _buildInfoRow(
                          context, Icons.wc_rounded, 'Kloset Jongkok'),
                      const Divider(color: Colors.white10, height: 32),

                      // --- 4. PERATURAN DI KOS INI ---
                      _buildSectionHeader(context, 'Peraturan di kos ini'),
                      _buildInfoRow(
                          context, Icons.access_time_rounded, 'Akses 24 Jam'),
                      _buildInfoRow(context, Icons.smoke_free_rounded,
                          'Dilarang merokok di kamar'),
                      const Divider(color: Colors.white10, height: 32),

                      // --- 5. LOKASI, MAPS & LINGKUNGAN (DINAMIS) ---
                      _buildSectionHeader(context, 'Lokasi & Lingkungan'),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.grey, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.lokasiLengkap,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // BOX MINI MAP PREVIEW
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: kCardDecoration(radius: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              IgnorePointer(
                                ignoring: true,
                                child: MapScreen(
                                  namaKost: widget.nama,
                                  lokasiKost: widget.lokasiLengkap,
                                ),
                              ),
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MapScreen(
                                            namaKost: widget.nama,
                                            lokasiKost: widget.lokasiLengkap,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // TOMBOL INTEGRASI KE FULL SCREEN MAP SCREEN
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(
                                namaKost: widget.nama,
                                lokasiKost: widget.lokasiLengkap,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 14),
                          decoration: BoxDecoration(
                            color: kCardBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: kPrimaryColor.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.map_outlined,
                                  color: Color(0xff14b8a6), size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Buka Peta Lokasi (OpenStreetMap)',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: kPrimaryColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // SEGMEN TEMPAT TERDEKAT (DINAMIS)
                      _buildSectionHeader(context, 'Tempat Terdekat'),
                      const SizedBox(height: 8),
                      Column(
                        children: widget.tempatTerdekat.map((tempat) {
                          return _buildLocationDetailRow(
                              context,
                              Icons.place_outlined,
                              tempat['nama'] ?? '',
                              tempat['jarak'] ?? '');
                        }).toList(),
                      ),

                      const SizedBox(height: 140),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. ACTION BOTTOM BAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    colors: [Color(0xffdc2626), Color(0xff991b1b)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.bolt,
                              color: Colors.yellowAccent, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Diskon Kilat Berlaku ',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 10),
                    ],
                  ),
                ),
                buildGlassContainer(
                  radius: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  widget.harga,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          color: kPrimaryLight,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' /bulan',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Estimasi Pembayaran',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => _openBooking(context),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: kPrimaryGradient,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 14),
                                  child: Text(
                                    'Ajukan Sewa',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPERS ---
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              gradient: kPrimaryGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: kPrimaryLight, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70, fontSize: 13, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDetailRow(
      BuildContext context, IconData icon, String place, String distance) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: kAccentLight, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Text(place,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70, fontSize: 13))),
          Text(distance,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white30, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTextButton(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 4),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white10),
          minimumSize: const Size(double.infinity, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white60,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
