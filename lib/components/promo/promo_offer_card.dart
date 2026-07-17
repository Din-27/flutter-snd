import 'package:flutter/material.dart';

class PromoOfferCard extends StatelessWidget {
  const PromoOfferCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.onUse,
  });

  final String title;
  final String subtitle;
  final String tag;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0EE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(tag, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6D6A69))),
                ],
              ),
            ),
            FilledButton(onPressed: onUse, child: const Text('Pakai')),
          ],
        ),
      ),
    );
  }
}
