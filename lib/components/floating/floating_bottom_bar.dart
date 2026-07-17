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

    const items = [
      _BottomBarItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'Home',
      ),
      _BottomBarItem(
        icon: Icons.precision_manufacturing_outlined,
        activeIcon: Icons.precision_manufacturing_rounded,
        label: 'Product',
      ),
      _BottomBarItem(
        icon: Icons.location_pin,
        activeIcon: Icons.location_pin,
        label: 'Workshop',
      ),
      _BottomBarItem(
        icon: Icons.newspaper_outlined,
        activeIcon: Icons.newspaper_rounded,
        label: 'Article',
      ),
      _BottomBarItem(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: 'Profile',
      ),
    ];

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          const BoxShadow(
            color: Color.fromARGB(38, 0, 0, 0),
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final badgeCount = index == 1 ? notificationCount : 0;

          return _buildBarItem(
            index: index,
            icon: item.icon,
            activeIcon: item.activeIcon,
            label: item.label,
            color: primaryColor,
            badgeCount: badgeCount,
          );
        }),
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

    Widget iconWidget = Icon(
      isActive ? activeIcon : icon,
      color: isActive ? color : const Color(0xFF7A6F6C),
      size: 24,
    );

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

class _BottomBarItem {
  const _BottomBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}
