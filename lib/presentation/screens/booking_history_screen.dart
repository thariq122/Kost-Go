import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../data/model/booking_model.dart';
import 'ui_helpers.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final userId = context.read<AuthProvider>().userId;
    if (userId > 0) {
      context.read<BookingProvider>().fetchUserBookings(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: kPrimaryGradient),
        ),
        title: Text('Riwayat Booking',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
                child: CircularProgressIndicator(color: kPrimaryColor));
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off_rounded,
                      color: Colors.white24, size: 56),
                  const SizedBox(height: 12),
                  Text(provider.errorMessage!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white38),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  TextButton(
                      onPressed: _loadData,
                      child: const Text('Coba Lagi',
                          style: TextStyle(color: kPrimaryLight))),
                ],
              ),
            );
          }

          if (provider.userBookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox_rounded,
                      color: Colors.white12, size: 64),
                  const SizedBox(height: 12),
                  Text('Belum ada riwayat booking',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white38)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            itemCount: provider.userBookings.length,
            itemBuilder: (context, i) =>
                _BookingCard(booking: provider.userBookings[i]),
          );
        },
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (booking.status) {
      case 'diterima':
        statusColor = const Color(0xff22c55e);
        break;
      case 'ditolak':
        statusColor = Colors.redAccent;
        break;
      default:
        statusColor = Colors.amber;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: kElevatedCardDecoration(radius: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(booking.namaKost,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(booking.statusLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Divider(color: Colors.white10, height: 20),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey, size: 14),
                const SizedBox(width: 6),
                Text('Masuk: ${booking.tanggalMasuk}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey, fontSize: 12)),
                const SizedBox(width: 16),
                const Icon(Icons.schedule, color: Colors.grey, size: 14),
                const SizedBox(width: 6),
                Text(booking.durasiText,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Biaya',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.grey, fontSize: 12)),
                Text(
                  _formatRupiah(booking.totalHarga),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: kPrimaryLight,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatRupiah(int nilai) {
    final s = nilai.toString();
    final buf = StringBuffer('Rp ');
    final mod = s.length % 3;
    buf.write(s.substring(0, mod == 0 ? 3 : mod));
    for (int i = mod == 0 ? 3 : mod; i < s.length; i += 3) {
      buf.write('.${s.substring(i, i + 3)}');
    }
    return buf.toString();
  }
}
