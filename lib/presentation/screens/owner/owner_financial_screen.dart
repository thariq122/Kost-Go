import 'package:flutter/material.dart';
import '../ui_helpers.dart';

class OwnerFinancialScreen extends StatefulWidget {
  const OwnerFinancialScreen({super.key});

  @override
  State<OwnerFinancialScreen> createState() => _OwnerFinancialScreenState();
}

class _OwnerFinancialScreenState extends State<OwnerFinancialScreen> {
  int _selectedMonth = 5; // 0-indexed: Mei = 4, Jun = 5

  final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  // Data dummy per bulan
  final Map<int, Map<String, dynamic>> _monthlyData = {
    4: {'income': 'Rp 11,8 Jt', 'paid': 11, 'unpaid': 4, 'growth': '+5%'},
    5: {'income': 'Rp 12,7 Jt', 'paid': 12, 'unpaid': 3, 'growth': '+7%'},
  };

  final List<Map<String, dynamic>> _transactions = [
    {
      'name': 'Andi Saputra',
      'room': 'Kamar 01',
      'amount': 'Rp 950.000',
      'date': '1 Jun 2026',
      'status': 'lunas',
    },
    {
      'name': 'Siti Rahayu',
      'room': 'Kamar 03',
      'amount': 'Rp 1.100.000',
      'date': '3 Jun 2026',
      'status': 'lunas',
    },
    {
      'name': 'Budi Santoso',
      'room': 'Kamar 05',
      'amount': 'Rp 900.000',
      'date': '5 Jun 2026',
      'status': 'belum',
    },
    {
      'name': 'Dewi Lestari',
      'room': 'Kamar 07',
      'amount': 'Rp 950.000',
      'date': '8 Jun 2026',
      'status': 'lunas',
    },
    {
      'name': 'Rizky Pratama',
      'room': 'Kamar 08',
      'amount': 'Rp 1.000.000',
      'date': '10 Jun 2026',
      'status': 'belum',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final data = _monthlyData[_selectedMonth] ??
        {'income': '-', 'paid': 0, 'unpaid': 0, 'growth': '-'};

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
                  Text('Laporan Keuangan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pilih bulan
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _months.length,
                        itemBuilder: (context, i) {
                          final isSelected = i == _selectedMonth;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedMonth = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: isSelected ? kPrimaryGradient : null,
                                color: isSelected ? null : kCardBg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: isSelected
                                        ? Colors.transparent
                                        : Colors.white12),
                              ),
                              child: Text(_months[i],
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: 12)),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Kartu pendapatan utama
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff16a34a), Color(0xff22c55e)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xff22c55e).withValues(alpha: 0.3),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Total Pendapatan — ${_months[_selectedMonth]} 2026',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 8),
                          Text(data['income'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 34)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.trending_up_rounded,
                                  color: Colors.white70, size: 16),
                              const SizedBox(width: 6),
                              Text('${data['growth']} dari bulan lalu',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Stat row
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            icon: Icons.check_circle_rounded,
                            color: kPrimaryColor,
                            label: 'Sudah Bayar',
                            value: '${data['paid']} Kamar',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            icon: Icons.pending_rounded,
                            color: Colors.orangeAccent,
                            label: 'Belum Bayar',
                            value: '${data['unpaid']} Kamar',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Riwayat transaksi
                    Row(
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
                        Text('Riwayat Transaksi',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 14),

                    ..._transactions
                        .map((t) => _buildTransactionRow(context, t)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context,
      {required IconData icon,
      required Color color,
      required String label,
      required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: kElevatedCardDecoration(radius: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey, fontSize: 11)),
              const SizedBox(height: 4),
              Text(value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(BuildContext context, Map<String, dynamic> t) {
    final isLunas = t['status'] == 'lunas';
    final statusColor = isLunas ? const Color(0xff22c55e) : Colors.orangeAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: kCardDecoration(radius: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isLunas
                  ? Icons.check_circle_rounded
                  : Icons.hourglass_empty_rounded,
              color: statusColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t['name'] as String,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                const SizedBox(height: 2),
                Text('${t['room']} • ${t['date']}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(t['amount'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(isLunas ? 'Lunas' : 'Belum',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
