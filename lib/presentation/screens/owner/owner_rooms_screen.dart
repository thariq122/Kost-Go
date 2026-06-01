import 'package:flutter/material.dart';
import '../ui_helpers.dart';

enum RoomStatus { terisi, kosong, renovasi }

class RoomData {
  final String number;
  final String tenant;
  final String price;
  final String facilities;
  RoomStatus status;

  RoomData({
    required this.number,
    required this.tenant,
    required this.price,
    required this.facilities,
    required this.status,
  });
}

class OwnerRoomsScreen extends StatefulWidget {
  final bool openAddRoom;
  const OwnerRoomsScreen({super.key, this.openAddRoom = false});

  @override
  State<OwnerRoomsScreen> createState() => _OwnerRoomsScreenState();
}

class _OwnerRoomsScreenState extends State<OwnerRoomsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.openAddRoom) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddRoomDialog(context);
      });
    }
  }

  final List<RoomData> _rooms = [
    RoomData(
        number: '01',
        tenant: 'Andi Saputra',
        price: 'Rp 950.000',
        facilities: 'AC • WiFi • K. Mandi Dalam',
        status: RoomStatus.terisi),
    RoomData(
        number: '02',
        tenant: '-',
        price: 'Rp 850.000',
        facilities: 'WiFi • Kasur • Lemari',
        status: RoomStatus.kosong),
    RoomData(
        number: '03',
        tenant: 'Siti Rahayu',
        price: 'Rp 1.100.000',
        facilities: 'AC • WiFi • K. Mandi Dalam • Kasur',
        status: RoomStatus.terisi),
    RoomData(
        number: '04',
        tenant: '-',
        price: 'Rp 750.000',
        facilities: 'WiFi • Kasur',
        status: RoomStatus.renovasi),
    RoomData(
        number: '05',
        tenant: 'Budi Santoso',
        price: 'Rp 900.000',
        facilities: 'AC • WiFi • Lemari',
        status: RoomStatus.terisi),
    RoomData(
        number: '06',
        tenant: '-',
        price: 'Rp 850.000',
        facilities: 'WiFi • Kasur • Meja',
        status: RoomStatus.kosong),
    RoomData(
        number: '07',
        tenant: 'Dewi Lestari',
        price: 'Rp 950.000',
        facilities: 'AC • WiFi • K. Mandi Dalam',
        status: RoomStatus.terisi),
    RoomData(
        number: '08',
        tenant: 'Rizky Pratama',
        price: 'Rp 1.000.000',
        facilities: 'AC • WiFi • K. Mandi Dalam • Kasur',
        status: RoomStatus.terisi),
  ];

  Color _statusColor(RoomStatus s) {
    switch (s) {
      case RoomStatus.terisi:
        return kPrimaryColor;
      case RoomStatus.kosong:
        return const Color(0xff22c55e);
      case RoomStatus.renovasi:
        return Colors.orangeAccent;
    }
  }

  String _statusLabel(RoomStatus s) {
    switch (s) {
      case RoomStatus.terisi:
        return 'Terisi';
      case RoomStatus.kosong:
        return 'Kosong';
      case RoomStatus.renovasi:
        return 'Renovasi';
    }
  }

  IconData _statusIcon(RoomStatus s) {
    switch (s) {
      case RoomStatus.terisi:
        return Icons.person_rounded;
      case RoomStatus.kosong:
        return Icons.door_front_door_outlined;
      case RoomStatus.renovasi:
        return Icons.construction_rounded;
    }
  }

  void _showRoomDetail(BuildContext context, RoomData room) {
    final TextEditingController priceController =
        TextEditingController(text: room.price);
    final TextEditingController facilitiesController =
        TextEditingController(text: room.facilities);
    RoomStatus selectedStatus = room.status;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16),
            child: buildGlassContainer(
              radius: 28,
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                    Text('Kamar ${room.number}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    const SizedBox(height: 20),
                    // Status selector
                    Text('Status Kamar',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 10),
                    Row(
                      children: RoomStatus.values.map((s) {
                        final isSelected = selectedStatus == s;
                        final color = _statusColor(s);
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () =>
                                  setModalState(() => selectedStatus = s),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color.withValues(alpha: 0.2)
                                      : Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color:
                                          isSelected ? color : Colors.white12),
                                ),
                                child: Column(
                                  children: [
                                    Icon(_statusIcon(s),
                                        color: isSelected ? color : Colors.grey,
                                        size: 18),
                                    const SizedBox(height: 4),
                                    Text(_statusLabel(s),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                                color: isSelected
                                                    ? color
                                                    : Colors.grey,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(context, 'Harga Sewa', priceController,
                        prefixIcon: Icons.payments_outlined),
                    const SizedBox(height: 14),
                    _buildInputField(context, 'Fasilitas', facilitiesController,
                        prefixIcon: Icons.checklist_rounded),
                    const SizedBox(height: 24),
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
                          setState(() {
                            room.status = selectedStatus;
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Kamar ${room.number} berhasil diperbarui'),
                              backgroundColor: kPrimaryColor,
                              duration: const Duration(seconds: 2),
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
                            child: Text('Simpan Perubahan',
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
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildInputField(
      BuildContext context, String label, TextEditingController controller,
      {IconData? prefixIcon}) {
    return buildGlassContainer(
      radius: 12,
      child: TextField(
        controller: controller,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: kPrimaryLight, size: 18)
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  void _showAddRoomDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16),
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
              Text('Tambah Kamar Baru',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              const SizedBox(height: 20),
              _buildInputField(context, 'Nomor Kamar', TextEditingController(),
                  prefixIcon: Icons.meeting_room_outlined),
              const SizedBox(height: 14),
              _buildInputField(context, 'Harga Sewa', TextEditingController(),
                  prefixIcon: Icons.payments_outlined),
              const SizedBox(height: 14),
              _buildInputField(context, 'Fasilitas', TextEditingController(),
                  prefixIcon: Icons.checklist_rounded),
              const SizedBox(height: 24),
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
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kamar baru berhasil ditambahkan'),
                        backgroundColor: kPrimaryColor,
                        duration: Duration(seconds: 2),
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
                      child: Text('Tambah Kamar',
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
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Manajemen Kamar',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                      Text('${_rooms.length} kamar terdaftar',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _showAddRoomDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add_rounded,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 4),
                          Text('Tambah',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Legend
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildLegend(context, kPrimaryColor, 'Terisi'),
                  const SizedBox(width: 16),
                  _buildLegend(context, const Color(0xff22c55e), 'Kosong'),
                  const SizedBox(width: 16),
                  _buildLegend(context, Colors.orangeAccent, 'Renovasi'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.1,
                ),
                itemCount: _rooms.length,
                itemBuilder: (context, index) {
                  final room = _rooms[index];
                  final color = _statusColor(room.status);
                  return GestureDetector(
                    onTap: () => _showRoomDetail(context, room),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kCardBg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: color.withValues(alpha: 0.3), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(_statusIcon(room.status),
                                    color: color, size: 18),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(_statusLabel(room.status),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                            color: color,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text('Kamar ${room.number}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                          const SizedBox(height: 2),
                          Text(
                            room.status == RoomStatus.terisi
                                ? room.tenant
                                : room.price,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: room.status == RoomStatus.terisi
                                        ? Colors.white60
                                        : color,
                                    fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey, fontSize: 11)),
      ],
    );
  }
}
