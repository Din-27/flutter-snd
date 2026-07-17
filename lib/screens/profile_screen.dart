import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/components/profile/profile_menu_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Profile',
      currentIndex: 4,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFFFF0EE),
                    child: Icon(Icons.person_rounded, color: Color(0xFF5C4E4B), size: 30),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Herdiyana', style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(height: 3),
                      Text('herdiyana@example.com', style: TextStyle(color: Color(0xFF6D6A69))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ProfileMenuTile(
            icon: Icons.receipt_long_rounded,
            title: 'Detail Transaksi',
            onTap: () => context.go('/transaction-detail'),
          ),
          ProfileMenuTile(
            icon: Icons.notifications_active_outlined,
            title: 'Notification',
            onTap: () => context.go('/notifications'),
          ),
          ProfileMenuTile(
            icon: Icons.payment_rounded,
            title: 'Checkout',
            onTap: () => context.go('/checkout'),
          ),
          ProfileMenuTile(
            icon: Icons.local_offer_rounded,
            title: 'Promo Tersimpan',
            onTap: () => context.go('/promo'),
          ),
          ProfileMenuTile(
            icon: Icons.location_pin,
            title: 'Monitoring Bengkel',
            onTap: () => context.go('/monitoring'),
          ),
          ProfileMenuTile(
            icon: Icons.login_rounded,
            title: 'Login / Register',
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}
