import 'package:flutter/material.dart';
import '../ui_helpers.dart';

enum BookingStatus { pending, accepted, rejected }

class BookingRequest {
  final String name;
  final String room;
  final String date;
  final String duration;
  final String phone;
  BookingStatus status;

  BookingRequest({
    required this.name,
    required this.room,
    required this.date,
    required this.duration,
    required this.phone,
    this.status = BookingStatus.pending,
  });
}

class OwnerBookingsScreen extends StatefulWidget {
  final int pendingCount;
  final ValueChanged<int> onCountChanged;

  const OwnerBookingsScreen({
    super.key,
    required this.pendingCount,
    required this.onCountChanged,
  });

  @override
  State<OwnerBookingsScreen> createState() => _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends State<OwnerBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<BookingRequest> _bookings = [
    BookingRequest(
        name: 'Rizky Pratama',
        room: 'Kamar 02',
        date: '1 Jun 2026',
        duration: '6 Bulan',
        phone: '08123456789',
        status: BookingStatus.pending),
    BookingRequest(
        name: 'Maya Sari',
        room: 'Kamar 06',
        date: '2 Jun 2026',
        duration: '12 Bulan',
        phone: '08234567890',
        status: BookingStatus.pending),
    BookingRequest(
        name: 'Andi Saputra',
        room: 'Kamar 01',
        date: '15 Mei 2026',
        duration: '12 Bulan',
        phone: '08345678901',
        status: BookingStatus.accepted),
    BookingRequest(
        name: 'Budi Santoso',
        room: 'Kamar 05',
        date: '10 Mei 2026',
        duration: '3 Bulan',
        phone: '08456789012',
        status: BookingStatus.rejected),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<BookingRequest> _filtered(BookingStatus status) =>
      _bookings.where((b) => b.status == status).toList();

  int get _pendingCount => _filtered(BookingStatus.pending).length;

  void _updateStatus(BookingRequest booking, BookingStatus newStatus) {
    setState(() {
      booking.status = newStatus;
    });
    widget.onCountChanged(_pendingCount);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(newStatus == BookingStatus.accepted
            ? 'Booking ${booking.name} diterima'
            : 'Booking ${booking.name} ditolak'),
        backgroundColor: newStatus == BookingStatus.accepted
            ? kPrimaryColor
            : Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showBookingDetail(BuildContext context, BookingRequest booking) {
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: kPrimaryLight, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                      Text(booking.phone,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailRow(
                  context, Icons.meeting_room_outlined, 'Kamar', booking.room),
              _buildDetailRow(context, Icons.calendar_today_outlined,
                  'Tanggal Masuk', booking.date),
              _buildDetailRow(context, Icons.timelapse_rounded, 'Durasi Sewa',
                  booking.duration),
              const SizedBox(height: 16),
              // Bukti Transfer placeholder
              Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.receipt_long_rounded,
                        color: Colors.white24, size: 36),
                    const SizedBox(height: 8),
                    Text('Bukti Transfer',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white38, fontSize: 12)),
                    Text('(Foto akan tampil di sini)',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white24, fontSize: 11)),
                  ],
                ),
              ),
              if (booking.status == BookingStatus.pending) ...[
                const SizedBox(height: 20),
                Row(
                  children: [
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
                          _updateStatus(booking, BookingStatus.rejected);
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
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _updateStatus(booking, BookingStatus.accepted);
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: kPrimaryGradient,
                            borderRadius: BorderRadius.circular(14),
                          ),
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
                  ],
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: kPrimaryLight, size: 16),
          const SizedBox(width: 10),
          Text('$label: ',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey, fontSize: 13)),
          Text(value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
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
                        Text('Kelola permintaan sewa kamar',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  if (_pendingCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.redAccent.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.circle,
                              color: Colors.redAccent, size: 8),
                          const SizedBox(width: 6),
                          Text('$_pendingCount Menunggu',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: buildGlassContainer(
                radius: 14,
                padding: const EdgeInsets.all(4),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: kPrimaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                          if (_pendingCount > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.all(3),
                              constraints: const BoxConstraints(
                                  minWidth: 16, minHeight: 16),
                              decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle),
                              child: Text('$_pendingCount',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Tab(text: 'Diterima'),
                    const Tab(text: 'Ditolak'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBookingList(context, _filtered(BookingStatus.pending)),
                  _buildBookingList(context, _filtered(BookingStatus.accepted)),
                  _buildBookingList(context, _filtered(BookingStatus.rejected)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(BuildContext context, List<BookingRequest> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_rounded, color: Colors.white12, size: 56),
            const SizedBox(height: 12),
            Text('Tidak ada pesanan',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white38)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final booking = list[index];
        Color statusColor;
        String statusText;
        switch (booking.status) {
          case BookingStatus.pending:
            statusColor = Colors.orangeAccent;
            statusText = 'Menunggu';
            break;
          case BookingStatus.accepted:
            statusColor = kPrimaryColor;
            statusText = 'Diterima';
            break;
          case BookingStatus.rejected:
            statusColor = Colors.redAccent;
            statusText = 'Ditolak';
            break;
        }

        return GestureDetector(
          onTap: () => _showBookingDetail(context, booking),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: kElevatedCardDecoration(radius: 18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child:
                      Icon(Icons.person_rounded, color: statusColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                      const SizedBox(height: 3),
                      Text('${booking.room} • ${booking.duration}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 3),
                      Text(booking.date,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(statusText,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    const Icon(Icons.chevron_right_rounded,
                        color: Colors.white24, size: 18),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
