import 'package:flutter/material.dart';
import 'ui_helpers.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg, // Dark Background
      appBar: AppBar(
        backgroundColor: kAppBarBg,
        title: Text(
          'Riwayat Booking',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        automaticallyImplyLeading: false, // Menghilangkan tombol back bawaan
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // Kartu Riwayat 1 (Status: Menunggu Persetujuan)
          _buildBookingCard(
            context,
            namaKost: 'Kost Mentari Agung',
            tanggalMasuk: '01 Juni 2026',
            durasi: '3 Bulan',
            totalHarga: 'Rp 3.600.000',
            status: 'Menunggu Persetujuan',
            statusColor: Colors.amber,
          ),
          const SizedBox(height: 16),

          // Kartu Riwayat 2 (Status: Disetujui / Aktif)
          _buildBookingCard(
            context,
            namaKost: 'Kost Putri Annisa',
            tanggalMasuk: '15 Mei 2026',
            durasi: '1 Bulan',
            totalHarga: 'Rp 1.500.000',
            status: 'Disetujui',
            statusColor: Colors.tealAccent,
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk membuat Kartu Riwayat Booking
  Widget _buildBookingCard(
    BuildContext context, {
    required String namaKost,
    required String tanggalMasuk,
    required String durasi,
    required String totalHarga,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(width: 0.5, color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row Atas: Nama Kost & Badge Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    namaKost,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey, height: 24, thickness: 0.2),

            // Info Detail: Tanggal & Durasi
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Masuk: $tanggalMasuk',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.schedule, color: Colors.grey, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Durasi: $durasi',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Row Bawah: Total Pembayaran
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Biaya',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Colors.grey[400], fontSize: 12),
                ),
                Text(
                  totalHarga,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
