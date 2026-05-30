import 'package:flutter/material.dart';
import 'ui_helpers.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'auth_selection_screen.dart';
import 'profile_screen.dart';

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
      _showLoginRequiredDialog();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Pop-up notifikasi estetik untuk menyuruh user login terlebih dahulu
  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kCardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Yuk, Masuk Akun dulu!',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Kamu harus masuk sebagai pencari kos untuk menikmati fitur Peta dan Booking.',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Nanti Saja',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor, // Teal color
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              setState(() {
                _selectedIndex = 3; // Alihkan otomatis ke tab 'Masuk/Profil'
              });
            },
            child: Text('Masuk Sekarang',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.white)),
          ),
        ],
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
      Scaffold(
        backgroundColor: kScaffoldBg,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.list_alt_rounded, color: Colors.grey, size: 64),
              const SizedBox(height: 16),
              Text(
                'Belum Ada Riwayat Booking',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Kos yang kamu sewa akan muncul di sini.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),

      // Tab 3: Pilihan Masuk / Profil (Dinamis & sudah dibersihkan)
      currentLoginStatus
          ? const ProfileScreen()
          : AuthSelectionScreen(
              onLoginSuccess: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
    ]; // Selesai ditutup dengan benar di sini

    return Scaffold(
      backgroundColor: kScaffoldBg,
      body: Stack(
        children: [
          Positioned.fill(
            child: screens[_selectedIndex],
          ),

          // MODERNHUD: KAPSUL NAVIGASI MELAYANG
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Container(
              decoration: kCardDecoration(radius: 28),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: (index) => _onItemTapped(index, currentLoginStatus),
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  selectedItemColor: kPrimaryColor,
                  unselectedItemColor: Colors.grey.shade500,
                  selectedFontSize: 11,
                  unselectedFontSize: 11,
                  iconSize: 22,
                  elevation: 0,
                  items: [
                    const BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Icons.home_filled),
                      ),
                      label: 'Beranda',
                    ),
                    const BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Icons.map_rounded),
                      ),
                      label: 'Peta',
                    ),
                    const BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Icons.list_alt_rounded),
                      ),
                      label: 'Booking',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Icon(currentLoginStatus
                            ? Icons.person_rounded
                            : Icons.login_rounded),
                      ),
                      label: currentLoginStatus ? 'Profil' : 'Masuk',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
