import 'package:flutter/material.dart';
import 'ui_helpers.dart';

class MapScreen extends StatelessWidget {
  final String namaKost;
  final String lokasiKost;

  const MapScreen({
    super.key,
    this.namaKost = "Kost Dipatiukur Regensi Tipe A",
    this.lokasiKost = "Coblong, Bandung (Dekat UNPAD/ITB)",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      appBar: AppBar(
        backgroundColor: kAppBarBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lokasi Kos (KostGo Maps)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              namaKost,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // 1. WIDGET PETA INTERAKTIF
          Center(
            child: InteractiveViewer(
              clipBehavior: Clip.none,
              maxScale: 5.0,
              minScale: 1.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/15/26176/16606.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child:
                            CircularProgressIndicator(color: Color(0xff14b8a6)),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: kCardDecoration(radius: 12),
                        child: const Center(
                          child:
                              Icon(Icons.map, color: Colors.white10, size: 80),
                        ),
                      );
                    },
                  ),

                  // Pin Lokasi Kost Melayang
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xff14b8a6).withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: Color(0xff14b8a6),
                          size: 42,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 2. KARTU INFORMASI ALAMAT MELAYANG (SUDAH DINAIKKAN AGAR TIDAK KETUTUP NAVIGASI)
          Positioned(
            bottom:
                100, // <--- DIUBAH KE 100 BIAR POSISINYA NAIK DAN KELIHATAN JELAS
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: kCardDecoration(radius: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kScaffoldBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.maps_home_work,
                        color: Color(0xff14b8a6), size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          namaKost,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lokasiKost,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Petunjuk Kecil
          Positioned(
            top: 12,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.pinch, color: Colors.white, size: 14),
                  const SizedBox(width: 6),
                  Text('Cubit untuk zoom peta',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white, fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
