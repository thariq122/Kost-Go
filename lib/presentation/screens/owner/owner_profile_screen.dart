import 'package:flutter/material.dart';
import '../ui_helpers.dart';
import 'owner_notification_screen.dart';

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  void _showEditProfile(BuildContext context) {
    final nameController = TextEditingController(text: 'Budi Hartono');
    final phoneController = TextEditingController(text: '08123456789');
    final emailController =
        TextEditingController(text: 'budi.hartono@email.com');

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
          child: SingleChildScrollView(
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
                Text('Edit Profil',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                const SizedBox(height: 20),
                _buildField(context, 'Nama Lengkap', nameController,
                    icon: Icons.person_outline_rounded),
                const SizedBox(height: 14),
                _buildField(context, 'Nomor HP', phoneController,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 14),
                _buildField(context, 'Email', emailController,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 24),
                _buildSaveButton(context, ctx, 'Simpan Profil'),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBankSettings(BuildContext context) {
    final bankController = TextEditingController(text: 'BCA');
    final accountController = TextEditingController(text: '1234567890');
    final nameController = TextEditingController(text: 'Budi Hartono');

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
          child: SingleChildScrollView(
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
                Text('Rekening Bank',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                const SizedBox(height: 6),
                Text(
                    'Nomor rekening ini yang akan ditampilkan ke pencari kos saat melakukan pembayaran.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 20),
                _buildField(context, 'Nama Bank', bankController,
                    icon: Icons.account_balance_outlined),
                const SizedBox(height: 14),
                _buildField(context, 'Nomor Rekening', accountController,
                    icon: Icons.credit_card_rounded,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 14),
                _buildField(context, 'Atas Nama', nameController,
                    icon: Icons.badge_outlined),
                const SizedBox(height: 24),
                _buildSaveButton(context, ctx, 'Simpan Rekening'),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showChangePassword(BuildContext context) {
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
              Text('Ubah Kata Sandi',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              const SizedBox(height: 20),
              _buildField(context, 'Password Lama', TextEditingController(),
                  icon: Icons.lock_outline_rounded, isPassword: true),
              const SizedBox(height: 14),
              _buildField(context, 'Password Baru', TextEditingController(),
                  icon: Icons.lock_rounded, isPassword: true),
              const SizedBox(height: 14),
              _buildField(
                  context, 'Konfirmasi Password Baru', TextEditingController(),
                  icon: Icons.lock_rounded, isPassword: true),
              const SizedBox(height: 24),
              _buildSaveButton(context, ctx, 'Ubah Password'),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
      BuildContext context, String label, TextEditingController controller,
      {IconData? icon, bool isPassword = false, TextInputType? keyboardType}) {
    return buildGlassContainer(
      radius: 12,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
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
          prefixIcon:
              icon != null ? Icon(icon, color: kPrimaryLight, size: 18) : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSaveButton(
      BuildContext context, BuildContext ctx, String label) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: () {
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label berhasil disimpan'),
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
            child: Text(label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            children: [
              // Header / Avatar section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      kPrimaryDark.withValues(alpha: 0.3),
                      Colors.transparent
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            gradient: kPrimaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const CircleAvatar(
                            radius: 44,
                            backgroundColor: kCardBg,
                            child: Icon(Icons.person_rounded,
                                color: kPrimaryLight, size: 44),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _showEditProfile(context),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                  color: kPrimaryColor, shape: BoxShape.circle),
                              child: const Icon(Icons.edit_rounded,
                                  color: Colors.white, size: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text('Budi Hartono',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    const SizedBox(height: 4),
                    Text('Pemilik Kos • Serpong, Tangerang',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 12),
                    buildAnimatedBadge('Pemilik Terverifikasi ✓'),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Menu sections
              _buildSectionHeader(context, 'Akun'),
              _buildMenuItem(
                context,
                icon: Icons.person_outline_rounded,
                iconColor: kPrimaryColor,
                title: 'Edit Profil',
                subtitle: 'Nama, nomor HP, email',
                onTap: () => _showEditProfile(context),
              ),
              _buildMenuItem(
                context,
                icon: Icons.account_balance_rounded,
                iconColor: const Color(0xff22c55e),
                title: 'Rekening Bank',
                subtitle: 'BCA • 1234567890',
                onTap: () => _showBankSettings(context),
              ),
              _buildMenuItem(
                context,
                icon: Icons.lock_outline_rounded,
                iconColor: const Color(0xff818cf8),
                title: 'Ubah Kata Sandi',
                subtitle: 'Ganti password akun',
                onTap: () => _showChangePassword(context),
              ),

              const SizedBox(height: 8),
              _buildSectionHeader(context, 'Lainnya'),
              _buildMenuItem(
                context,
                icon: Icons.notifications_outlined,
                iconColor: kPrimaryLight,
                title: 'Notifikasi',
                subtitle: 'Pemberitahuan pesanan masuk',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const OwnerNotificationScreen()),
                ),
              ),
              _buildMenuItem(
                context,
                icon: Icons.logout_rounded,
                iconColor: Colors.redAccent,
                title: 'Keluar',
                subtitle: 'Logout dari akun pemilik',
                onTap: () => _showLogoutConfirm(context),
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Text(title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2)),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: kCardDecoration(radius: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                isDestructive ? Colors.redAccent : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.white24, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kCardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Keluar?',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text('Kamu akan keluar dari akun pemilik kos.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text('Keluar',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
