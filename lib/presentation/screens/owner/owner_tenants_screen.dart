import 'package:flutter/material.dart';
import '../ui_helpers.dart';

class TenantData {
  final String name;
  final String room;
  final String phone;
  final String dueDate;
  final String rentPrice;
  final bool isDueSoon; // jatuh tempo dalam 3 hari

  const TenantData({
    required this.name,
    required this.room,
    required this.phone,
    required this.dueDate,
    required this.rentPrice,
    this.isDueSoon = false,
  });
}

class OwnerTenantsScreen extends StatefulWidget {
  const OwnerTenantsScreen({super.key});

  @override
  State<OwnerTenantsScreen> createState() => _OwnerTenantsScreenState();
}

class _OwnerTenantsScreenState extends State<OwnerTenantsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<TenantData> _tenants = const [
    TenantData(
        name: 'Andi Saputra',
        room: 'Kamar 01',
        phone: '08123456789',
        dueDate: '5 Jun 2026',
        rentPrice: 'Rp 950.000',
        isDueSoon: true),
    TenantData(
        name: 'Siti Rahayu',
        room: 'Kamar 03',
        phone: '08234567890',
        dueDate: '10 Jun 2026',
        rentPrice: 'Rp 1.100.000'),
    TenantData(
        name: 'Budi Santoso',
        room: 'Kamar 05',
        phone: '08345678901',
        dueDate: '15 Jun 2026',
        rentPrice: 'Rp 900.000'),
    TenantData(
        name: 'Dewi Lestari',
        room: 'Kamar 07',
        phone: '08456789012',
        dueDate: '20 Jun 2026',
        rentPrice: 'Rp 950.000'),
    TenantData(
        name: 'Rizky Pratama',
        room: 'Kamar 08',
        phone: '08567890123',
        dueDate: '25 Jun 2026',
        rentPrice: 'Rp 1.000.000'),
  ];

  List<TenantData> get _filtered {
    if (_searchQuery.isEmpty) return _tenants;
    return _tenants
        .where((t) =>
            t.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            t.room.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _openWhatsApp(BuildContext context, TenantData tenant) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membuka WhatsApp untuk ${tenant.name}...'),
        backgroundColor: const Color(0xff25d366),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showTenantDetail(BuildContext context, TenantData tenant) {
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
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 20),
              // Avatar
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: kPrimaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: kPrimaryColor.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6))
                  ],
                ),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 32),
              ),
              const SizedBox(height: 14),
              Text(tenant.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              const SizedBox(height: 4),
              Text(tenant.room,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: kPrimaryLight, fontSize: 13)),
              const SizedBox(height: 24),
              // Info rows
              _buildInfoTile(
                  context, Icons.phone_rounded, 'Nomor HP', tenant.phone),
              _buildInfoTile(context, Icons.payments_rounded, 'Harga Sewa',
                  tenant.rentPrice),
              _buildInfoTile(
                  context, Icons.event_rounded, 'Jatuh Tempo', tenant.dueDate,
                  valueColor:
                      tenant.isDueSoon ? Colors.orangeAccent : Colors.white),
              const SizedBox(height: 20),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0xff25d366), width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _openWhatsApp(context, tenant);
                      },
                      icon: const Icon(Icons.chat_rounded,
                          color: Color(0xff25d366), size: 18),
                      label: Text('WhatsApp',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: const Color(0xff25d366),
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      icon: Ink(
                        decoration: BoxDecoration(
                          gradient: kPrimaryGradient,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.receipt_long_rounded,
                                  color: Colors.white, size: 18),
                              const SizedBox(width: 6),
                              Text('Tagih Kos',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      label: const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
      BuildContext context, IconData icon, String label, String value,
      {Color valueColor = Colors.white}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: kCardDecoration(radius: 12),
      child: Row(
        children: [
          Icon(icon, color: kPrimaryLight, size: 16),
          const SizedBox(width: 12),
          Text('$label  ',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey, fontSize: 13)),
          const Spacer(),
          Text(value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: kScaffoldBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daftar Penghuni',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  Text('${_tenants.length} penghuni aktif',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: buildGlassContainer(
                radius: 14,
                height: 48,
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    const Icon(Icons.search_rounded,
                        color: Colors.grey, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Cari nama atau nomor kamar...',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey, fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Due soon banner
            if (_tenants.any((t) => t.isDueSoon))
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.orangeAccent.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Colors.orangeAccent, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '${_tenants.where((t) => t.isDueSoon).length} penghuni jatuh tempo dalam 3 hari',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.orangeAccent, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            // List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text('Penghuni tidak ditemukan',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white38)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final tenant = filtered[index];
                        return GestureDetector(
                          onTap: () => _showTenantDetail(context, tenant),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: kElevatedCardDecoration(radius: 18),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: kPrimaryGradient,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.person_rounded,
                                      color: Colors.white, size: 20),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(tenant.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14)),
                                          if (tenant.isDueSoon) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.orangeAccent
                                                    .withValues(alpha: 0.15),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text('Jatuh Tempo',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall
                                                      ?.copyWith(
                                                          color: Colors
                                                              .orangeAccent,
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                          '${tenant.room} • ${tenant.rentPrice}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          const Icon(Icons.event_rounded,
                                              color: Colors.white38, size: 12),
                                          const SizedBox(width: 4),
                                          Text('Jatuh tempo: ${tenant.dueDate}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      color: tenant.isDueSoon
                                                          ? Colors.orangeAccent
                                                          : Colors.white38,
                                                      fontSize: 11)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // WhatsApp button
                                GestureDetector(
                                  onTap: () => _openWhatsApp(context, tenant),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff25d366)
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: const Color(0xff25d366)
                                              .withValues(alpha: 0.3)),
                                    ),
                                    child: const Icon(Icons.chat_rounded,
                                        color: Color(0xff25d366), size: 18),
                                  ),
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
}
