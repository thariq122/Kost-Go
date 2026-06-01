import 'dart:ui';
import 'package:flutter/material.dart';
import 'ui_helpers.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'auth_selection_screen.dart';
import 'profile_screen.dart';
import 'booking_history_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Fungsi pengecekan akses sebelum pindah tab navigasi bawah
  void _onItemTapped(int index, bool isLoggedIn) {
    // Jika user menekan tab Peta (index 1) atau Booking (index 2) tapi BELUM login
    if ((index == 1 || index == 2) && !isLoggedIn) {
      _showLoginRequiredSheet();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Pop-up notifikasi estetik untuk menyuruh user login terlebih dahulu
  void _showLoginRequiredSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: buildGlassContainer(
          radius: 32,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_person_rounded,
                    size: 56, color: kPrimaryLight),
              ),
              const SizedBox(height: 24),
              Text(
                'Yuk, Masuk Akun dulu!',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Kamu harus masuk sebagai pencari kos untuk menikmati fitur Peta dan Booking.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog
                    setState(() {
                      _selectedIndex = 3; // Alihkan otomatis ke tab 'Masuk/Profil'
                    });
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: kPrimaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text('Masuk Sekarang',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Nanti Saja',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bool currentLoginStatus = authProvider.isLoggedIn;

    // Menghubungkan ke seluruh halaman utama aplikasi
    final List<Widget> screens = [
      // Tab 0: Beranda
      HomeScreen(isLoggedIn: currentLoginStatus),

      // Tab 1: Peta KostGo
      const MapScreen(),

      // Tab 2: Halaman Booking Kosan
      const BookingHistoryScreen(),

      // Tab 3: Pilihan Masuk / Profil
      currentLoginStatus
          ? const ProfileScreen()
          : AuthSelectionScreen(
              onLoginSuccess: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
    ];

    return Scaffold(
      backgroundColor: kScaffoldBg,
      extendBody: true, // Biar background nembus nav bar
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: buildGlassContainer(
            radius: 32,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_filled, 'Beranda', currentLoginStatus),
                _buildNavItem(1, Icons.map_rounded, 'Peta', currentLoginStatus),
                _buildNavItem(2, Icons.list_alt_rounded, 'Booking', currentLoginStatus),
                _buildNavItem(3, currentLoginStatus ? Icons.person_rounded : Icons.login_rounded, 
                  currentLoginStatus ? 'Profil' : 'Masuk', currentLoginStatus),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isLoggedIn) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index, isLoggedIn),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 20 : 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? kPrimaryColor.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? kPrimaryLight : Colors.grey.shade500,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: kPrimaryLight,
                    fontWeight: FontWeight.bold),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

