import 'package:flutter/material.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/components/notification/notification_item_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const _items = [
    _NotificationItem(
      title: 'Teknisi sedang menuju lokasi Anda',
      body: 'ETA 12 menit. Pantau perjalanan di menu Workshop.',
      time: '2 menit lalu',
      unread: true,
    ),
    _NotificationItem(
      title: 'Pembayaran berhasil diverifikasi',
      body: 'Transaksi INV-20260717-0001 telah diterima.',
      time: '20 menit lalu',
      unread: true,
    ),
    _NotificationItem(
      title: 'Promo baru tersedia',
      body: 'Diskon servis 25% khusus home service hari ini.',
      time: '1 jam lalu',
      unread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Notification',
      currentIndex: 0,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = _items[index];
          return NotificationItemTile(
            title: item.title,
            body: item.body,
            time: item.time,
            unread: item.unread,
          );
        },
      ),
    );
  }
}

class _NotificationItem {
  const _NotificationItem({
    required this.title,
    required this.body,
    required this.time,
    required this.unread,
  });

  final String title;
  final String body;
  final String time;
  final bool unread;
}
