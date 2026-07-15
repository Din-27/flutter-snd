import 'package:flutter/material.dart';

class FloatingBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int notificationCount;

  const FloatingBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(209, 41, 58, 1);
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.only(
          topLeft: Radius.zero,
          topRight: Radius.zero,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(38, 0, 0, 0), //
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Menu 1: Home
          _buildBarItem(
            index: 0,
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Home',
            color: primaryColor,
          ),

          // Menu 2: Notification (Dengan Kondisi Badge)
          _buildBarItem(
            index: 1,
            icon: Icons.precision_manufacturing_outlined,
            activeIcon: Icons.precision_manufacturing_rounded,
            label: 'Product',
            color: primaryColor,
            // badgeCount: notificationCount, // Mengirim data jumlah notif
          ),

          // Menu 3: Profile
          _buildBarItem(
            index: 2,
            icon: Icons.location_pin,
            activeIcon: Icons.location_pin,
            label: 'workshop',
            color: primaryColor,
          ),
          _buildBarItem(
            index: 2,
            icon: Icons.newspaper_outlined,
            activeIcon: Icons.newspaper_rounded,
            label: 'Article',
            color: primaryColor,
          ),
          _buildBarItem(
            index: 2,
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: 'Profile',
            color: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildBarItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color color,
    int badgeCount = 0,
  }) {
    final bool isActive = currentIndex == index;

    // Menentukan widget icon (apakah dibungkus badge atau tidak)
    Widget iconWidget = Icon(
      isActive ? activeIcon : icon,
      color: isActive ? color : const Color(0xFF7A6F6C),
      size: 24,
    );

    // Mengaplikasikan kondisi badge > 0 seperti menu yang kita perbaiki kemarin
    if (badgeCount > 0) {
      iconWidget = Badge(
        backgroundColor: color,
        label: Text(
          '$badgeCount',
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
        ),
        child: iconWidget,
      );
    }

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? color : const Color(0xFF7A6F6C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
