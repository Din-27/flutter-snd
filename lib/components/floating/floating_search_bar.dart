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
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EE),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 28, 28).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.speed_outlined,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              cursorColor: const Color(0xFFFFF0EE),
              decoration: const InputDecoration(
                hintText: 'Find a workshop near you...',
                hintStyle: TextStyle(color: Color(0xFF7A6F6C), fontSize: 16),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          GestureDetector(
            onTap: onFilterPressed,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0EE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Color(0xFF5C4E4B),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
