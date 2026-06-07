import 'package:flutter/material.dart';
import 'ui_helpers.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // 1. FUNGSI LOGOUT (Tetap sama)
  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: kCardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Keluar Akun',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah kamu yakin ingin keluar dari akun KostGo?',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Batal',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              Provider.of<AuthProvider>(context, listen: false).logout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Berhasil keluar dari akun'),
                  backgroundColor: Colors.teal,
                ),
              );
            },
            child: Text('Keluar',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: kScaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Avatar — tanpa fungsi ganti foto
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: kCardBg,
                  child: const Icon(Icons.person,
                      size: 50, color: Colors.tealAccent),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                authProvider.userName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                '${authProvider.userEmail} • Pencari Kost',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[500], fontSize: 14),
              ),
              const SizedBox(height: 32),

              // 2. KARTU DETAIL AKUN (Tetap sama)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: kElevatedCardDecoration(radius: 16),
                child: Column(
                  children: [
                    _buildInfoRow(context, 'Nomor WhatsApp',
                        authProvider.userPhone, Icons.phone),
                    const Divider(
                        color: Colors.white24, height: 24, thickness: 0.5),
                    _buildInfoRow(context, 'Status Akun', 'Terverifikasi',
                        Icons.verified_user),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. DAFTAR MENU OPSI (Tetap sama)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pengaturan Aplikasi',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: kElevatedCardDecoration(radius: 16),
                child: Column(
                  children: [
                    _buildMenuTile(
                      context,
                      'Edit Profil',
                      Icons.edit_outlined,
                      Colors.white,
                      () => _navigateToEditProfile(context),
                    ),
                    const Divider(
                        color: Colors.white24, height: 1, thickness: 0.5),
                    _buildMenuTile(
                      context,
                      'Keluar Akun',
                      Icons.logout,
                      Colors.redAccent,
                      () => _handleLogout(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, String title, String value, IconData icon) {
    return Row(
      children: [
        buildGlassContainer(
          radius: 12,
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: kPrimaryLight, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[400], fontSize: 12)),
            const SizedBox(height: 4),
            Text(value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuTile(BuildContext context, String title, IconData icon,
      Color textColor, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon,
            color: textColor == Colors.redAccent
                ? Colors.redAccent
                : kPrimaryLight),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
        onTap: onTap,
      ),
    );
  }
}
