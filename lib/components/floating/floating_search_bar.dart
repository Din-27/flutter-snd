import 'package:flutter/material.dart';

class FloatingSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onFilterPressed;
  final ValueChanged<String>? onChanged;

  const FloatingSearchBar({
    super.key,
    this.controller,
    this.onFilterPressed,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56, // Tinggi standar search bar yang nyaman ditekan
      decoration: BoxDecoration(
        // Menggunakan warna latar belakang abu-abu terang agak hangat sesuai gambar
        color: const Color(0xFFEBE6E4),
        borderRadius: BorderRadius.circular(
          30,
        ), // Membuat sudut membulat sempurna
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // 1. IKON SPEEDOMETER (KIRI)
          const Icon(
            Icons.speed_outlined, // Padanan ikon speedometer bawaan Flutter
            color: Color.fromRGBO(209, 41, 58, 1), // Warna Merah Astra Anda
            size: 24,
          ),
          const SizedBox(width: 12),

          // 2. INPUT TEKS (TENGAH)
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              cursorColor: const Color.fromRGBO(209, 41, 58, 1),
              decoration: const InputDecoration(
                hintText: 'Find a workshop near you...',
                hintStyle: TextStyle(
                  color: Color(
                    0xFF7A6F6C,
                  ), // Warna teks hint agak kecokelatan/redup
                  fontSize: 16,
                ),
                border: InputBorder
                    .none, // Menghilangkan garis bawah default TextField
                isDense:
                    true, // Menyeimbangkan vertikal alignment teks di dalam Row
              ),
            ),
          ),

          // 3. TOMBOL FILTER BULAT (KANAN)
          GestureDetector(
            onTap: onFilterPressed,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(
                  0xFFFFE3E1,
                ), // Background merah muda pucat di sekitar tombol filter
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.tune_rounded, // Ikon filter/adjustment sliders
                color: Color(0xFF5C4E4B), // Warna ikon filter gelap hangat
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
