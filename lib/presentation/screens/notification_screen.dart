import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'auth_selection_screen.dart';
import 'ui_helpers.dart';

enum NotifType { booking, payment, info, promo }

class NotifItem {
  final String title;
  final String body;
  final String time;
  final NotifType type;
  bool isRead;

  NotifItem({
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Notifikasi hanya relevan saat sudah login
  final List<NotifItem> _notifications = [
    NotifItem(
      title: 'Booking Disetujui! 🎉',
      body:
          'Selamat! Pengajuan sewa Kost Wisma Serasi Tipe A kamu telah disetujui oleh pemilik kos.',
      time: '5 menit lalu',
      type: NotifType.booking,
      isRead: false,
    ),
    NotifItem(
      title: 'Pembayaran Dikonfirmasi',
      body:
          'Pembayaran Rp 950.000 untuk Kamar 03 bulan Juni 2026 telah diterima.',
      time: '1 jam lalu',
      type: NotifType.payment,
      isRead: false,
    ),
    NotifItem(
      title: 'Jatuh Tempo Besok',
      body:
          'Pembayaran kos kamu jatuh tempo besok, 2 Jun 2026. Segera lakukan pembayaran.',
      time: '3 jam lalu',
      type: NotifType.info,
      isRead: false,
    ),
    NotifItem(
      title: 'Promo Spesial Akhir Bulan 🔥',
      body:
          'Diskon hingga Rp 500rb untuk sewa kos baru bulan ini. Berlaku sampai 30 Jun 2026.',
      time: 'Kemarin',
      type: NotifType.promo,
      isRead: true,
    ),
    NotifItem(
      title: 'Booking Menunggu Konfirmasi',
      body:
          'Pengajuan sewa Pondok Gusgas 2 sedang ditinjau pemilik kos. Harap tunggu 1x24 jam.',
      time: '2 hari lalu',
      type: NotifType.booking,
      isRead: true,
    ),
    NotifItem(
      title: 'Selamat Datang di KostGo!',
      body:
          'Akun kamu berhasil dibuat. Mulai cari kos impianmu sekarang dan nikmati promo member baru.',
      time: '5 hari lalu',
      type: NotifType.info,
      isRead: true,
    ),
  ];

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  void _markRead(NotifItem item) {
    setState(() => item.isRead = true);
  }

  Color _typeColor(NotifType t) {
    switch (t) {
      case NotifType.booking:
        return kPrimaryColor;
      case NotifType.payment:
        return const Color(0xff22c55e);
      case NotifType.info:
        return Colors.orangeAccent;
      case NotifType.promo:
        return const Color(0xff9333ea);
    }
  }

  IconData _typeIcon(NotifType t) {
    switch (t) {
      case NotifType.booking:
        return Icons.assignment_turned_in_rounded;
      case NotifType.payment:
        return Icons.payments_rounded;
      case NotifType.info:
        return Icons.info_rounded;
      case NotifType.promo:
        return Icons.local_offer_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<AuthProvider>(context).isLoggedIn;

    return Scaffold(
      backgroundColor: kScaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  buildGlassContainer(
                    radius: 14,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                      padding: const EdgeInsets.all(10),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Notifikasi',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                        if (isLoggedIn && _unreadCount > 0)
                          Text('$_unreadCount belum dibaca',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: kPrimaryLight, fontSize: 12)),
                      ],
                    ),
                  ),
                  if (isLoggedIn && _unreadCount > 0)
                    GestureDetector(
                      onTap: _markAllRead,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: kPrimaryColor.withValues(alpha: 0.3)),
                        ),
                        child: Text('Tandai semua',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: kPrimaryLight,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Konten: guest state atau list notifikasi
            Expanded(
              child: !isLoggedIn
                  ? _buildGuest(context)
                  : _notifications.isEmpty
                      ? _buildEmpty(context)
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                          itemCount: _notifications.length,
                          itemBuilder: (context, index) {
                            final notif = _notifications[index];
                            return _buildNotifCard(context, notif);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifCard(BuildContext context, NotifItem notif) {
    final color = _typeColor(notif.type);
    return GestureDetector(
      onTap: () => _markRead(notif),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notif.isRead ? kCardBg : color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: notif.isRead
                ? Colors.white.withValues(alpha: 0.05)
                : color.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_typeIcon(notif.type), color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(notif.title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: notif.isRead
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                    fontSize: 13)),
                      ),
                      if (!notif.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: color, shape: BoxShape.circle),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(notif.body,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey, fontSize: 12, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(notif.time,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white30, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuest(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: kPrimaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                    color: kPrimaryColor.withValues(alpha: 0.2), width: 1.5),
              ),
              child: const Icon(Icons.notifications_off_outlined,
                  color: kPrimaryLight, size: 48),
            ),
            const SizedBox(height: 24),
            Text(
              'Masuk untuk lihat notifikasi',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            const SizedBox(height: 10),
            Text(
              'Notifikasi booking, pembayaran, dan promo khusus hanya tersedia setelah kamu masuk.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Arahkan ke tab Masuk di MainNavigation
                  // Cukup pop — user bisa tap tab Masuk sendiri
                  // Atau buka AuthSelectionScreen langsung:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AuthSelectionScreen(
                        onLoginSuccess: () => Navigator.pop(context),
                      ),
                    ),
                  );
                },
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Masuk Sekarang',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_off_outlined,
              color: Colors.white12, size: 64),
          const SizedBox(height: 16),
          Text('Belum ada notifikasi',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white38, fontSize: 15)),
          const SizedBox(height: 8),
          Text('Notifikasi booking dan pembayaran\nakan muncul di sini.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white24, fontSize: 13)),
        ],
      ),
    );
  }
}
