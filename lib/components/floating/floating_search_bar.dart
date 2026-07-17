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
        color: const Color(0xFFEBE6E4),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(
            Icons.speed_outlined,
            color: Color.fromRGBO(209, 41, 58, 1),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              cursorColor: const Color.fromRGBO(209, 41, 58, 1),
              decoration: const InputDecoration(
                hintText: 'Find a workshop near you...',
                hintStyle: TextStyle(
                  color: Color(0xFF7A6F6C),
                  fontSize: 16,
                ),
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
                color: Color(0xFFFFE3E1),
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
