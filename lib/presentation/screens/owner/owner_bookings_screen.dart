import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ui_helpers.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/booking_provider.dart';
import '../../../providers/owner_stats_provider.dart';
import '../../../data/model/booking_model.dart';

class OwnerBookingsScreen extends StatefulWidget {
  const OwnerBookingsScreen({super.key});

  @override
  State<OwnerBookingsScreen> createState() => _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends State<OwnerBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final pemilikId = context.read<AuthProvider>().userId;
    if (pemilikId > 0) {
      context.read<BookingProvider>().fetchOwnerBookings(pemilikId);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<BookingModel> _filtered(BookingProvider p, String status) =>
      p.ownerBookings.where((b) => b.status == status).toList();

  Future<void> _updateStatus(BookingModel booking, String newStatus) async {
    final pemilikId = context.read<AuthProvider>().userId;
    final ok = await context.read<BookingProvider>().updateStatus(
          bookingId: booking.id,
          pemilikId: pemilikId,
          status: newStatus,
        );
    if (!mounted) return;

    if (ok) {
      // Refresh stats supaya pendapatan langsung update di dashboard
      context.read<OwnerStatsProvider>().fetchStats(pemilikId);
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok
          ? 'Booking ${booking.namaPenyewa} ${newStatus == 'diterima' ? 'diterima' : 'ditolak'}'
          : 'Gagal memperbarui status'),
      backgroundColor: ok
          ? (newStatus == 'diterima' ? kPrimaryColor : Colors.redAccent)
          : Colors.orange,
      duration: const Duration(seconds: 2),
    ));
  }

  void _showDetail(BuildContext context, BookingModel booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: buildGlassContainer(
          radius: 28,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.person_rounded,
                      color: kPrimaryLight, size: 28),
                ),
                const SizedBox(width: 14),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(booking.namaPenyewa,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(booking.noHpPenyewa,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey)),
                ]),
              ]),
              const SizedBox(height: 20),
              _detailRow(context, Icons.home_rounded, 'Kost', booking.namaKost),
              _detailRow(context, Icons.calendar_today_outlined,
                  'Tanggal Masuk', booking.tanggalMasuk),
              _detailRow(context, Icons.timelapse_rounded, 'Durasi',
                  booking.durasiText),
              _detailRow(
                  context,
                  Icons.payments_outlined,
                  'Metode',
                  booking.metodeBayar == 'transfer'
                      ? 'Transfer Bank'
                      : 'Tunai'),
              const SizedBox(height: 8),
              // Bukti transfer
              Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: booking.buktiTransfer != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          '${ApiEndpoints.baseUrl}/${booking.buktiTransfer}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                                child: CircularProgressIndicator(
                                    color: kPrimaryColor, strokeWidth: 2));
                          },
                          errorBuilder: (_, __, ___) => const Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image_rounded,
                                  color: Colors.white24, size: 36),
                              SizedBox(height: 6),
                              Text('Gambar tidak dapat dimuat',
                                  style: TextStyle(
                                      color: Colors.white38, fontSize: 11)),
                            ],
                          )),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            const Icon(Icons.receipt_long_rounded,
                                color: Colors.white24, size: 36),
                            const SizedBox(height: 8),
                            Text('Belum ada bukti transfer',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Colors.white38, fontSize: 12)),
                          ]),
              ),
              if (booking.status == 'pending') ...[
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _updateStatus(booking, 'ditolak');
                      },
                      child: Text('Tolak',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _updateStatus(booking, 'diterima');
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: kPrimaryGradient,
                            borderRadius: BorderRadius.circular(14)),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Text('Terima',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Icon(icon, color: kPrimaryLight, size: 16),
        const SizedBox(width: 10),
        Text('$label: ',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey, fontSize: 13)),
        Expanded(
          child: Text(value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(builder: (context, provider, _) {
      final pending = _filtered(provider, 'pending');
      final diterima = _filtered(provider, 'diterima');
      final ditolak = _filtered(provider, 'ditolak');
      final pendingCount = pending.length;

      return Scaffold(
        backgroundColor: kScaffoldBg,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pesanan Masuk',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                          Text('Kelola permintaan sewa kos',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey, fontSize: 12)),
                        ]),
                  ),
                  if (pendingCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.redAccent.withValues(alpha: 0.4)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.circle,
                            color: Colors.redAccent, size: 8),
                        const SizedBox(width: 6),
                        Text('$pendingCount Menunggu',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11)),
                      ]),
                    ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded,
                        color: Colors.white70, size: 20),
                    onPressed: _loadData,
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: buildGlassContainer(
                  radius: 14,
                  padding: const EdgeInsets.all(4),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.circular(10)),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                    tabs: [
                      Tab(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            const Text('Pending'),
                            if (pendingCount > 0) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.all(3),
                                constraints: const BoxConstraints(
                                    minWidth: 16, minHeight: 16),
                                decoration: const BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle),
                                child: Text('$pendingCount',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ])),
                      const Tab(text: 'Diterima'),
                      const Tab(text: 'Ditolak'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (provider.isLoading)
                const Expanded(
                    child: Center(
                        child: CircularProgressIndicator(color: kPrimaryColor)))
              else
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildList(context, pending),
                      _buildList(context, diterima),
                      _buildList(context, ditolak),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildList(BuildContext context, List<BookingModel> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.inbox_rounded, color: Colors.white12, size: 56),
          const SizedBox(height: 12),
          Text('Tidak ada pesanan',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white38)),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final b = list[i];
        Color statusColor;
        String statusText;
        switch (b.status) {
          case 'pending':
            statusColor = Colors.orangeAccent;
            statusText = 'Menunggu';
            break;
          case 'diterima':
            statusColor = kPrimaryColor;
            statusText = 'Diterima';
            break;
          default:
            statusColor = Colors.redAccent;
            statusText = 'Ditolak';
        }
        return GestureDetector(
          onTap: () => _showDetail(context, b),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: kElevatedCardDecoration(radius: 18),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14)),
                child: Icon(Icons.person_rounded, color: statusColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.namaPenyewa,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                      const SizedBox(height: 3),
                      Text(b.durasiText,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 3),
                      Text(b.tanggalMasuk,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white38, fontSize: 11)),
                    ]),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(statusText,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                const Icon(Icons.chevron_right_rounded,
                    color: Colors.white24, size: 18),
              ]),
            ]),
          ),
        );
      },
    );
  }
}
