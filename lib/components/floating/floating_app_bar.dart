import 'package:flutter/material.dart';

class FloatingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController? controller;
  final VoidCallback? onFilterPressed;

  const FloatingAppBar({super.key, this.controller, this.onFilterPressed});

  @override
  Widget build(BuildContext context) {
    const int notif = 1;

    return SafeArea(
      minimum: const EdgeInsets.only(top: 12, left: 16, right: 16),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(62, 0, 0, 0).withValues(), 
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Perbaikan sintaksis di sini
          children: [
            // Logo Container dengan Clip agar sudut gambar ikut tumpul
            Container(
              clipBehavior: Clip
                  .antiAlias, // Memotong gambar agar mengikuti kelengkungan border
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

            // Sisi Kanan: Tombol Notifikasi dengan Badge
            GestureDetector(
              onTap: onFilterPressed,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  shape: BoxShape.circle,
                ),
                child: notif > 0
                    ? const Badge(
                        backgroundColor: Color.fromRGBO(209, 41, 58, 1),
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
