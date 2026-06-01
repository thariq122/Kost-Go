import 'package:flutter/material.dart';
import '../ui_helpers.dart';
import 'owner_home_screen.dart';
import 'owner_rooms_screen.dart';
import 'owner_bookings_screen.dart';
import 'owner_tenants_screen.dart';
import 'owner_profile_screen.dart';

class OwnerMainNavigation extends StatefulWidget {
  const OwnerMainNavigation({super.key});

  @override
  State<OwnerMainNavigation> createState() => _OwnerMainNavigationState();
}

class _OwnerMainNavigationState extends State<OwnerMainNavigation> {
  int _selectedIndex = 0;

  // Jumlah booking pending — di production ini dari state/provider
  int pendingBookings = 2;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const OwnerHomeScreen(),
      const OwnerRoomsScreen(),
      OwnerBookingsScreen(
        pendingCount: pendingBookings,
        onCountChanged: (val) => setState(() => pendingBookings = val),
      ),
      const OwnerTenantsScreen(),
      const OwnerProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: kScaffoldBg,
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: buildGlassContainer(
            radius: 32,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_filled, 'Beranda'),
                _buildNavItem(1, Icons.meeting_room_rounded, 'Kamar'),
                _buildNavItemWithBadge(
                    2, Icons.assignment_rounded, 'Pesanan', pendingBookings),
                _buildNavItem(3, Icons.people_rounded, 'Penghuni'),
                _buildNavItem(4, Icons.manage_accounts_rounded, 'Profil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 16 : 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? kPrimaryColor.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 22,
                color: isSelected ? kPrimaryLight : Colors.grey.shade500),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: kPrimaryLight, fontWeight: FontWeight.bold)),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildNavItemWithBadge(
      int index, IconData icon, String label, int badgeCount) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 16 : 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? kPrimaryColor.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon,
                    size: 22,
                    color: isSelected ? kPrimaryLight : Colors.grey.shade500),
                if (badgeCount > 0)
                  Positioned(
                    top: -6,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      constraints:
                          const BoxConstraints(minWidth: 16, minHeight: 16),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: kPrimaryLight, fontWeight: FontWeight.bold)),
            ]
          ],
        ),
      ),
    );
  }
}
