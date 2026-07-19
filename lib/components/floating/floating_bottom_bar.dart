import 'package:flutter/material.dart';
import 'package:shop_and_drive/core/theme/app_theme.dart';

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
    const items = [
      _BottomBarItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
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
      _BottomBarItem(icon: Icons.newspaper_outlined, activeIcon: Icons.newspaper_rounded, label: 'Article'),
      _BottomBarItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
    ];

    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EBF1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
    required bool isCenter,
    int badgeCount = 0,
  }) {
    final bool isActive = currentIndex == index;

    // Center button
    if (isCenter) {
      return Expanded(
        child: InkWell(
          onTap: () => onTap(index),
          customBorder: const CircleBorder(),
          child: Transform.translate(
            offset: const Offset(0, -14),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, Color(0xFFA91F33)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.location_pin, color: Colors.white, size: 28),
            ),
          ),
        ),
      );
    }

    Widget iconWidget = Icon(
      isActive ? activeIcon : icon,
      color: isActive ? AppTheme.primary : AppTheme.textSecondary,
      size: 22,
    );

    if (badgeCount > 0) {
      iconWidget = Badge(
        backgroundColor: AppTheme.secondary,
        label: Text(
          '$badgeCount',
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        child: iconWidget,
      );
    }

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: iconWidget,
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppTheme.primary : AppTheme.textSecondary,
              ),
              child: Text(label),
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