import 'package:flutter/material.dart';
import '../ui_helpers.dart';
import 'owner_notification_screen.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  // Jumlah notif yang belum dibaca — di production dari provider/state
  int _unreadNotifCount = 3;

  void _markAllNotifsRead() {
    setState(() => _unreadNotifCount = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildStatsRow(context),
              const SizedBox(height: 28),
              _buildSectionLabel(context, 'Aktivitas Terbaru'),
              const SizedBox(height: 14),
              _buildRecentActivity(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selamat Datang,',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 2),
              Text('Pak Budi 👋',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22)),
            ],
          ),
          Row(
            children: [
              // Tombol notifikasi dengan badge
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OwnerNotificationScreen(
                        onAllRead: _markAllNotifsRead,
                      ),
                    ),
                  );
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    buildGlassContainer(
                      radius: 14,
                      padding: const EdgeInsets.all(10),
                      child: const Icon(Icons.notifications_outlined,
                          color: Colors.white70, size: 24),
                    ),
                    if (_unreadNotifCount > 0)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          constraints:
                              const BoxConstraints(minWidth: 18, minHeight: 18),
                          decoration: const BoxDecoration(
                              color: Colors.redAccent, shape: BoxShape.circle),
                          child: Text(
                            '$_unreadNotifCount',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              buildGlassContainer(
                radius: 14,
                padding: const EdgeInsets.all(2),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: kCardBg,
                  child: Icon(Icons.person_rounded,
                      color: kPrimaryLight, size: 22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.payments_rounded,
              iconColor: const Color(0xff22c55e),
              label: 'Pendapatan Bulan Ini',
              value: 'Rp 12,7 Jt',
              sub: '+Rp 850rb dari bulan lalu',
              subColor: const Color(0xff22c55e),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.pending_actions_rounded,
              iconColor: Colors.orangeAccent,
              label: 'Menunggu Konfirmasi',
              value: '2 Pesanan',
              sub: 'Segera ditinjau',
              subColor: Colors.orangeAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String sub,
    required Color subColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: kElevatedCardDecoration(radius: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey, fontSize: 11),
              maxLines: 2),
          const SizedBox(height: 6),
          Text(value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
          const SizedBox(height: 4),
          Text(sub,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: subColor, fontSize: 10),
              maxLines: 2),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
          Text(title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final activities = [
      {
        'icon': Icons.check_circle_rounded,
        'color': const Color(0xff22c55e),
        'title': 'Booking Diterima',
        'sub': 'Kamar 03 — Andi Saputra',
        'time': '2 jam lalu',
      },
      {
        'icon': Icons.payments_rounded,
        'color': kPrimaryColor,
        'title': 'Pembayaran Masuk',
        'sub': 'Kamar 07 — Rp 950.000',
        'time': 'Kemarin',
      },
      {
        'icon': Icons.warning_amber_rounded,
        'color': Colors.orangeAccent,
        'title': 'Jatuh Tempo Besok',
        'sub': 'Kamar 11 — Siti Rahayu',
        'time': '1 hari lagi',
      },
      {
        'icon': Icons.cancel_rounded,
        'color': Colors.redAccent,
        'title': 'Booking Dibatalkan',
        'sub': 'Kamar 05 — Budi Santoso',
        'time': '3 hari lalu',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: activities.map((a) {
          final color = a['color'] as Color;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: kCardDecoration(radius: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(a['icon'] as IconData, color: color, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a['title'] as String,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                      const SizedBox(height: 3),
                      Text(a['sub'] as String,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Text(a['time'] as String,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white38, fontSize: 11)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
