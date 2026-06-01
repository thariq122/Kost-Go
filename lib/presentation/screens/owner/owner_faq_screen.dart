import 'package:flutter/material.dart';
import '../ui_helpers.dart';

class _FaqItem {
  final String question;
  final String answer;
  bool isExpanded;

  _FaqItem({
    required this.question,
    required this.answer,
  }) : isExpanded = false;
}

class OwnerFaqScreen extends StatefulWidget {
  const OwnerFaqScreen({super.key});

  @override
  State<OwnerFaqScreen> createState() => _OwnerFaqScreenState();
}

class _OwnerFaqScreenState extends State<OwnerFaqScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.home_work_rounded, 'label': 'Kamar', 'color': kPrimaryColor},
    {
      'icon': Icons.payments_rounded,
      'label': 'Pembayaran',
      'color': const Color(0xff22c55e)
    },
    {
      'icon': Icons.people_rounded,
      'label': 'Penghuni',
      'color': Colors.orangeAccent
    },
    {
      'icon': Icons.settings_rounded,
      'label': 'Akun',
      'color': const Color(0xff818cf8)
    },
  ];

  final List<_FaqItem> _faqs = [
    _FaqItem(
      question: 'Bagaimana cara menambah kamar baru?',
      answer:
          'Buka tab "Kamar" lalu tap tombol "+ Tambah" di pojok kanan atas. Isi nomor kamar, harga sewa, dan fasilitas, kemudian tap "Tambah Kamar".',
    ),
    _FaqItem(
      question: 'Bagaimana cara mengubah harga sewa kamar?',
      answer:
          'Di tab "Kamar", tap kartu kamar yang ingin diubah. Pada bottom sheet yang muncul, edit kolom "Harga Sewa" lalu tap "Simpan Perubahan".',
    ),
    _FaqItem(
      question: 'Bagaimana cara mengkonfirmasi booking masuk?',
      answer:
          'Buka tab "Pesanan" → pilih tab "Pending". Tap kartu booking yang ingin ditinjau, lihat detail dan bukti transfer, lalu tap "Terima" atau "Tolak".',
    ),
    _FaqItem(
      question: 'Bagaimana cara menghubungi penghuni?',
      answer:
          'Buka tab "Penghuni", cari nama penghuni, lalu tap ikon WhatsApp hijau di samping namanya. Kamu juga bisa tap kartu penghuni untuk melihat detail lengkap.',
    ),
    _FaqItem(
      question: 'Bagaimana cara mengatur nomor rekening bank?',
      answer:
          'Buka tab "Profil" → tap "Rekening Bank". Isi nama bank, nomor rekening, dan nama pemilik rekening, lalu tap "Simpan Rekening".',
    ),
    _FaqItem(
      question: 'Bagaimana cara melihat laporan keuangan?',
      answer:
          'Dari beranda, tap shortcut "Laporan Keuangan". Kamu bisa memilih bulan untuk melihat total pendapatan, jumlah kamar yang sudah/belum bayar, dan riwayat transaksi.',
    ),
    _FaqItem(
      question: 'Bagaimana cara mengubah status kamar menjadi renovasi?',
      answer:
          'Di tab "Kamar", tap kartu kamar yang ingin diubah. Pada bagian "Status Kamar", pilih "Renovasi", lalu tap "Simpan Perubahan".',
    ),
    _FaqItem(
      question: 'Bagaimana cara mengatur aturan kosan?',
      answer:
          'Buka tab "Profil" → tap "Aturan Kosan". Edit teks aturan sesuai kebutuhan, lalu tap "Simpan Aturan". Aturan ini akan ditampilkan ke calon penghuni.',
    ),
    _FaqItem(
      question: 'Apakah saya bisa menghapus kamar yang sudah ada?',
      answer:
          'Saat ini penghapusan kamar dilakukan melalui tim support KostGo. Hubungi kami melalui email support@kostgo.id atau WhatsApp resmi kami.',
    ),
    _FaqItem(
      question: 'Bagaimana jika penghuni tidak membayar tepat waktu?',
      answer:
          'Kamu akan mendapat notifikasi jatuh tempo. Buka tab "Penghuni", cari penghuni yang belum bayar (ditandai badge "Jatuh Tempo"), lalu tap ikon WhatsApp untuk mengingatkan langsung.',
    ),
  ];

  List<_FaqItem> get _filtered {
    if (_searchQuery.isEmpty) return _faqs;
    return _faqs
        .where((f) =>
            f.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            f.answer.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bantuan & FAQ',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                      Text('Pusat bantuan pemilik kos',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search
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
                          hintText: 'Cari pertanyaan...',
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
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kategori (hanya tampil saat tidak search)
                    if (_searchQuery.isEmpty) ...[
                      Text('Kategori',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2)),
                      const SizedBox(height: 12),
                      Row(
                        children: _categories.map((c) {
                          final color = c['color'] as Color;
                          return Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: color.withValues(alpha: 0.2)),
                                ),
                                child: Column(
                                  children: [
                                    Icon(c['icon'] as IconData,
                                        color: color, size: 22),
                                    const SizedBox(height: 6),
                                    Text(c['label'] as String,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                                color: Colors.white70,
                                                fontSize: 10)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      Text('Pertanyaan Umum',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2)),
                      const SizedBox(height: 12),
                    ],

                    // FAQ list
                    if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: Text('Pertanyaan tidak ditemukan',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white38)),
                        ),
                      )
                    else
                      ...filtered.map((faq) => _buildFaqTile(context, faq)),

                    const SizedBox(height: 24),

                    // Kontak support
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: kPrimaryColor.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.support_agent_rounded,
                                  color: kPrimaryLight, size: 20),
                              const SizedBox(width: 10),
                              Text('Masih butuh bantuan?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Hubungi tim support KostGo yang siap membantu kamu.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    height: 1.4),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _buildContactButton(
                                  context,
                                  icon: Icons.chat_rounded,
                                  label: 'WhatsApp',
                                  color: const Color(0xff25d366),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildContactButton(
                                  context,
                                  icon: Icons.email_outlined,
                                  label: 'Email',
                                  color: kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTile(BuildContext context, _FaqItem faq) {
    return GestureDetector(
      onTap: () => setState(() => faq.isExpanded = !faq.isExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              faq.isExpanded ? kPrimaryColor.withValues(alpha: 0.07) : kCardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: faq.isExpanded
                ? kPrimaryColor.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(faq.question,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: faq.isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: faq.isExpanded ? kPrimaryLight : Colors.grey,
                    size: 20,
                  ),
                ),
              ],
            ),
            if (faq.isExpanded) ...[
              const SizedBox(height: 10),
              const Divider(color: Colors.white10, height: 1),
              const SizedBox(height: 10),
              Text(faq.answer,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey, fontSize: 13, height: 1.5)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton(BuildContext context,
      {required IconData icon, required String label, required Color color}) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Membuka $label support...'),
            backgroundColor: color,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
