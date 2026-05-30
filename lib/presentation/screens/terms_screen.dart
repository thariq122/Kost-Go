import 'package:flutter/material.dart';
import 'ui_helpers.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      appBar: AppBar(
        backgroundColor: kAppBarBg,
        elevation: 0,
        title: Text('Syarat & Ketentuan',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ketentuan Penggunaan KostGo',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Terakhir diperbarui: Mei 2026',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[500], fontSize: 12)),
            const Divider(color: Colors.grey, height: 32, thickness: 0.2),
            _buildTermSection(context, '1. Penerimaan Ketentuan',
                'Dengan mengunduh atau menggunakan aplikasi KostGo, Anda secara otomatis menyetujui seluruh syarat dan ketentuan yang berlaku di sini. Jika Anda tidak menyetujuinya, mohon untuk tidak menggunakan layanan kami.'),
            _buildTermSection(context, '2. Akun Pengguna',
                'Pencari kos wajib memberikan informasi pendaftaran yang akurat, termasuk nomor WhatsApp aktif untuk kebutuhan komunikasi dan verifikasi data dengan pemilik properti.'),
            _buildTermSection(context, '3. Kebijakan Booking',
                'Setiap transaksi booking atau penyewaan kamar kos yang terjadi di luar sistem pembayaran resmi KostGo merupakan tanggung jawab penuh antara pencari kos dan pemilik kos.'),
            _buildTermSection(context, '4. Keamanan & Hak Cipta',
                'KostGo berhak memblokir akun yang terindikasi melakukan penipuan, spamming, atau menyebarkan konten ulasan kos yang tidak pantas serta melanggar hukum.'),
          ],
        ),
      ),
    );
  }

  Widget _buildTermSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: kPrimaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(content,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey, fontSize: 13, height: 1.5),
              textAlign: TextAlign.justify),
        ],
      ),
    );
  }
}
