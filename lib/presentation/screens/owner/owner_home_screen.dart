import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ui_helpers.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/owner_stats_provider.dart';
import '../../../data/model/owner_stats_model.dart';
import 'owner_notification_screen.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final pemilikId = context.read<AuthProvider>().userId;
    if (pemilikId > 0) {
      context.read<OwnerStatsProvider>().fetchStats(pemilikId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: kScaffoldBg,
      body: SafeArea(
        child: RefreshIndicator(
          color: kPrimaryColor,
          backgroundColor: kCardBg,
          onRefresh: () async => _loadData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, auth.userName),
                const SizedBox(height: 20),
                Consumer<OwnerStatsProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                            child: CircularProgressIndicator(
                                color: kPrimaryColor)),
                      );
                    }
                    if (provider.errorMessage != null) {
                      return _buildErrorState(context, provider.errorMessage!);
                    }
                    final stats = provider.stats;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsRow(context, stats),
                        const SizedBox(height: 28),
                        _buildSectionLabel(context, 'Aktivitas Terbaru'),
                        const SizedBox(height: 14),
                        if (stats == null || stats.aktivitasTerbaru.isEmpty)
                          _buildEmptyActivity(context)
                        else
                          _buildActivityList(context, stats.aktivitasTerbaru),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String nama) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Selamat Datang,',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 2),
            Text(
              nama.isNotEmpty ? nama : 'Pemilik Kos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ]),
          Row(children: [
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          const OwnerNotificationScreen(onAllRead: null))),
              child: buildGlassContainer(
                radius: 14,
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.notifications_outlined,
                    color: Colors.white70, size: 24),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: Column(children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.white24, size: 48),
          const SizedBox(height: 12),
          Text(msg,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white38)),
          const SizedBox(height: 16),
          TextButton(
              onPressed: _loadData,
              child: const Text('Coba Lagi',
                  style: TextStyle(color: kPrimaryLight))),
        ]),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, OwnerStatsModel? stats) {
    final pendapatan = stats?.pendapatanFormatted ?? 'Rp 0';
    final selisih = stats?.selisihFormatted ?? '+Rp 0 dari bulan lalu';
    final pendingCount = stats?.pendingCount ?? 0;
    final selisihColor = (stats?.selisihPendapatan ?? 0) >= 0
        ? const Color(0xff22c55e)
        : Colors.redAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.payments_rounded,
            iconColor: const Color(0xff22c55e),
            label: 'Pendapatan Bulan Ini',
            value: pendapatan,
            sub: selisih,
            subColor: selisihColor,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.pending_actions_rounded,
            iconColor: Colors.orangeAccent,
            label: 'Menunggu Konfirmasi',
            value: '$pendingCount Pesanan',
            sub: pendingCount > 0 ? 'Segera ditinjau' : 'Semua sudah diproses',
            subColor: pendingCount > 0
                ? Colors.orangeAccent
                : const Color(0xff22c55e),
          ),
        ),
      ]),
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
      ]),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
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
      ]),
    );
  }

  Widget _buildEmptyActivity(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: Column(children: [
          const Icon(Icons.inbox_rounded, color: Colors.white12, size: 48),
          const SizedBox(height: 10),
          Text('Belum ada aktivitas',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white38)),
        ]),
      ),
    );
  }

  Widget _buildActivityList(
      BuildContext context, List<OwnerActivityItem> list) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: list.map((a) {
          IconData icon;
          Color color;
          String judul;

          switch (a.status) {
            case 'diterima':
              icon = Icons.check_circle_rounded;
              color = const Color(0xff22c55e);
              judul = 'Booking Diterima';
              break;
            case 'ditolak':
              icon = Icons.cancel_rounded;
              color = Colors.redAccent;
              judul = 'Booking Ditolak';
              break;
            default:
              icon = Icons.pending_actions_rounded;
              color = Colors.orangeAccent;
              judul = 'Booking Baru Masuk';
          }

          // Format waktu relatif
          final time = _relativeTime(a.createdAt);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: kCardDecoration(radius: 16),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(judul,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                      const SizedBox(height: 3),
                      Text('${a.namaKost} — ${a.namaPenyewa}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(a.metodeBayarLabel,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: a.metodeBayar == 'tunai'
                                      ? Colors.orangeAccent
                                      : kPrimaryLight,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500)),
                    ]),
              ),
              Text(time,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white38, fontSize: 11)),
            ]),
          );
        }).toList(),
      ),
    );
  }

  String _relativeTime(String createdAt) {
    try {
      final dt = DateTime.parse(createdAt);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes} mnt lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam lalu';
      if (diff.inDays == 1) return 'Kemarin';
      if (diff.inDays < 7) return '${diff.inDays} hari lalu';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }
}
