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
    const activeBackgroundColor = Color(0xFFFFF0EE);
    const inactiveIconColor = Color(0xFF7A6F6C);
    const activeIconColor = Color(0xFF5C4E4B);
    const badgeColor = Color(0xFF5C4E4B);

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
        isCenter: true,
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
      height: 80,
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
            activeBackgroundColor: activeBackgroundColor,
            activeIconColor: activeIconColor,
            inactiveIconColor: inactiveIconColor,
            badgeColor: badgeColor,
            badgeCount: badgeCount,
            isCenter: item.isCenter,
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
    required Color activeBackgroundColor,
    required Color activeIconColor,
    required Color inactiveIconColor,
    required Color badgeColor,
    required bool isCenter,
    int badgeCount = 0,
  }) {
    final bool isActive = currentIndex == index;

    Widget iconWidget = Icon(
      isActive ? activeIcon : icon,
      color: isActive ? activeIconColor : inactiveIconColor,
      size: isCenter ? 30 : 22,
    );

    if (badgeCount > 0) {
      iconWidget = Badge(
        backgroundColor: badgeColor,
        label: Text(
          '$badgeCount',
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
        ),
        child: iconWidget,
      );
    }

    final iconContainer = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: isCenter ? (isActive ? 62 : 58) : 42,
      height: isCenter ? (isActive ? 62 : 58) : 36,
      decoration: BoxDecoration(
        color: isActive ? activeBackgroundColor : Colors.transparent,
        shape: isCenter ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCenter ? null : BorderRadius.circular(12),
        boxShadow: isCenter
            ? [
                const BoxShadow(
                  color: Color.fromARGB(35, 0, 0, 0),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: iconWidget,
    );

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isCenter)
              Transform.translate(offset: const Offset(0, -6), child: iconContainer)
            else
              iconContainer,
            SizedBox(height: isCenter ? 0 : 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? activeIconColor : inactiveIconColor,
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
    this.isCenter = false,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isCenter;
}
