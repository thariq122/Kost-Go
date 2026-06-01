import 'package:flutter/material.dart';
import 'login_pencari_screen.dart';
import 'login_pemilik_screen.dart';
import 'ui_helpers.dart';

class AuthSelectionScreen extends StatelessWidget {
  const AuthSelectionScreen({super.key, required this.onLoginSuccess});
  final VoidCallback onLoginSuccess;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.close, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masuk ke KostGo',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Saya ingin masuk sebagai',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 30),
            _buildRoleCard(
              context,
              'Pencari Kos',
              'Cari dan sewa kos dengan mudah',
              Icons.person_search,
              const LoginPencariScreen(),
            ),
            const SizedBox(height: 20),
            _buildRoleCard(
              context,
              'Pemilik Kos',
              'Kelola dan pasang iklan kos Anda',
              Icons.home_work,
              const LoginPemilikScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, String title, String desc,
      IconData icon, Widget target) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => target)),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: kElevatedCardDecoration(radius: 16),
        child: Row(
          children: [
            buildGlassContainer(
              radius: 16,
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: kPrimaryLight, size: 36),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(desc,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey, fontSize: 13, height: 1.4)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
