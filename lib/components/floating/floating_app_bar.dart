import 'package:flutter/material.dart';

class FloatingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController? controller;
  final VoidCallback? onFilterPressed;

  const FloatingAppBar({super.key, this.controller, this.onFilterPressed});

  static const _badgeColor = Color.fromRGBO(209, 41, 58, 1);

  @override
  Widget build(BuildContext context) {
    const int notif = 1;

    return SafeArea(
      minimum: const EdgeInsets.only(top: 12, left: 16, right: 16),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            const BoxShadow(
              color: Color.fromARGB(62, 0, 0, 0),
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromARGB(255, 196, 39, 39),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                'assets/images/logo.png',
                width: 40,
              ),
            ),
            GestureDetector(
              onTap: onFilterPressed,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: notif > 0
                    ? const Badge(
                        backgroundColor: _badgeColor,
                        smallSize: 8,
                        child: Icon(Icons.notifications_outlined, size: 20),
                      )
                    : const Icon(Icons.notifications_outlined, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
