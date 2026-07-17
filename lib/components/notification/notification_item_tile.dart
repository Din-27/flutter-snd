import 'package:flutter/material.dart';

class NotificationItemTile extends StatelessWidget {
  const NotificationItemTile({
    super.key,
    required this.title,
    required this.body,
    required this.time,
    required this.unread,
  });

  final String title;
  final String body;
  final String time;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: unread ? const Color(0xFFFFF8F7) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0EE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_active_outlined,
                size: 20,
                color: Color(0xFF5C4E4B),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(body, style: const TextStyle(fontSize: 12, color: Color(0xFF6D6A69))),
                  const SizedBox(height: 6),
                  Text(time, style: const TextStyle(fontSize: 11, color: Color(0xFF8E8A88))),
                ],
              ),
            ),
            if (unread)
              const Padding(
                padding: EdgeInsets.only(top: 5),
                child: CircleAvatar(radius: 4, backgroundColor: Color(0xFF5C4E4B)),
              ),
          ],
        ),
      ),
    );
  }
}
