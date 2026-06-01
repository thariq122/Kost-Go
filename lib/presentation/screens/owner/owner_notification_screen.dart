import 'package:flutter/material.dart';
import '../ui_helpers.dart';

enum OwnerNotifType { booking, payment, info, warning }

class OwnerNotifItem {
  final String title;
  final String body;
  final String time;
  final OwnerNotifType type;
  bool isRead;

  OwnerNotifItem({
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

class OwnerNotificationScreen extends StatefulWidget {
  final VoidCallback? onAllRead;

  const OwnerNotificationScreen({super.key, this.onAllRead});

  @override
  State<OwnerNotificationScreen> createState() =>
      _OwnerNotificationScreenState();
}

class _OwnerNotificationScreenState extends State<OwnerNotificationScreen> {
  final List<OwnerNotifItem> _notifications = [
    OwnerNotifItem(
      title: 'Booking Baru Masuk! 🔔',
      body:
          'Rizky Pratama mengajukan sewa Kamar 02 selama 6 bulan. Segera tinjau dan konfirmasi.',
      time: '5 menit lalu',
      type: OwnerNotifType.booking,
      isRead: false,
    ),
    OwnerNotifItem(
      title: 'Pembayaran Diterima',
      body:
          'Siti Rahayu (Kamar 03) telah melakukan pembayaran Rp 1.100.000 untuk bulan Juni 2026.',
      time: '1 jam lalu',
      type: OwnerNotifType.payment,
      isRead: false,
    ),
    OwnerNotifItem(
      title: 'Jatuh Tempo Besok ⚠️',
      body:
          'Andi Saputra (Kamar 01) belum melakukan pembayaran. Jatuh tempo besok, 2 Jun 2026.',
      time: '3 jam lalu',
      type: OwnerNotifType.warning,
      isRead: false,
    ),
    OwnerNotifItem(
      title: 'Booking Kedua Masuk',
      body:
          'Maya Sari mengajukan sewa Kamar 06 selama 12 bulan mulai 2 Jun 2026.',
      time: 'Kemarin',
      type: OwnerNotifType.booking,
      isRead: true,
    ),
    OwnerNotifItem(
      title: 'Pembayaran Dikonfirmasi',
      body:
          'Dewi Lestari (Kamar 07) — pembayaran Rp 950.000 bulan Mei 2026 berhasil dikonfirmasi.',
      time: '2 hari lalu',
      type: OwnerNotifType.payment,
      isRead: true,
    ),
    OwnerNotifItem(
      title: 'Kamar 04 Siap Disewakan',
      body:
          'Renovasi Kamar 04 selesai. Jangan lupa ubah status kamar menjadi "Kosong".',
      time: '3 hari lalu',
      type: OwnerNotifType.info,
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
    widget.onAllRead?.call();
  }

  void _markRead(OwnerNotifItem item) {
    setState(() => item.isRead = true);
  }

  Color _typeColor(OwnerNotifType t) {
    switch (t) {
      case OwnerNotifType.booking:
        return kPrimaryColor;
      case OwnerNotifType.payment:
        return const Color(0xff22c55e);
      case OwnerNotifType.warning:
        return Colors.orangeAccent;
      case OwnerNotifType.info:
        return const Color(0xff818cf8);
    }
  }

  IconData _typeIcon(OwnerNotifType t) {
    switch (t) {
      case OwnerNotifType.booking:
        return Icons.assignment_rounded;
      case OwnerNotifType.payment:
        return Icons.payments_rounded;
      case OwnerNotifType.warning:
        return Icons.warning_amber_rounded;
      case OwnerNotifType.info:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        if (_unreadCount > 0)
                          Text('$_unreadCount belum dibaca',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: kPrimaryLight, fontSize: 12)),
                      ],
                    ),
                  ),
                  if (_unreadCount > 0)
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

            Expanded(
              child: _notifications.isEmpty
                  ? _buildEmpty(context)
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) =>
                          _buildCard(context, _notifications[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, OwnerNotifItem notif) {
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
