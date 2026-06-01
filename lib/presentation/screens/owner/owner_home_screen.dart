import 'package:flutter/material.dart';
import '../ui_helpers.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({super.key});

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
              _buildOccupancyCard(context),
              const SizedBox(height: 20),
              _buildStatsRow(context),
              const SizedBox(height: 28),
              _buildSectionLabel(context, 'Shortcut Cepat'),
              const SizedBox(height: 14),
              _buildShortcuts(context),
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
              Stack(
                clipBehavior: Clip.none,
                children: [
                  buildGlassContainer(
                    radius: 14,
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.notifications_outlined,
                        color: Colors.white70, size: 24),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          color: Colors.redAccent, shape: BoxShape.circle),
                    ),
                  ),
                ],
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

  Widget _buildOccupancyCard(BuildContext context) {
    const int terisi = 12;
    const int total = 15;
    const double persen = terisi / total;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff0d9488), Color(0xff14b8a6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tingkat Hunian',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$terisi',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 42),
                          ),
                          TextSpan(
                            text: '/$total Kamar',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${(persen * 100).toInt()}%',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: persen,
                minHeight: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Text('${total - terisi} kamar masih kosong',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white70, fontSize: 12)),
          ],
        ),
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

  Widget _buildShortcuts(BuildContext context) {
    final shortcuts = [
      {
        'icon': Icons.add_home_work_rounded,
        'label': 'Tambah\nKamar',
        'color': kPrimaryColor
      },
      {
        'icon': Icons.assignment_turned_in_rounded,
        'label': 'Konfirmasi\nPesanan',
        'color': Colors.orangeAccent
      },
      {
        'icon': Icons.chat_bubble_outline_rounded,
        'label': 'Hubungi\nPenghuni',
        'color': const Color(0xff22c55e)
      },
      {
        'icon': Icons.bar_chart_rounded,
        'label': 'Laporan\nKeuangan',
        'color': const Color(0xff818cf8)
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: shortcuts.map((s) {
          final color = s['color'] as Color;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      Icon(s['icon'] as IconData, color: color, size: 26),
                      const SizedBox(height: 8),
                      Text(s['label'] as String,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  height: 1.4)),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
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
