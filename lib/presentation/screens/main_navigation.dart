import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // 4 Halaman Utama
  final List<Widget> _screens = [
    const Center(child: Text('Halaman Home (Rekomendasi Kost)')),
    const Center(child: Text('Halaman Maps (Cari lewat Peta)')),
    const Center(
        child:
            Text('Halaman Riwayat Booking (Simulasi Transaksi)')), // Menu baru
    const Center(child: Text('Halaman Profil (Akun Pencari/Pemilik)')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        indicatorColor: Colors.teal.shade100,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map, color: Colors.black),
            label: 'Maps',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined), // Icon catatan transaksi
            selectedIcon: Icon(Icons.assignment, color: Colors.black),
            label: 'Booking',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Colors.black),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
