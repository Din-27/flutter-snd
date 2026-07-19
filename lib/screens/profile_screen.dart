import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/core/theme/app_theme.dart';

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
          // Profile Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, Color(0xFFA91F33)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 3),
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person_rounded, color: Colors.white, size: 44),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Herdiyana',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'herdiyana@example.com',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StatChip(label: '2.450', subtitle: 'Poin'),
                    const SizedBox(width: 24),
                    _StatChip(label: '12', subtitle: 'Transaksi'),
                    const SizedBox(width: 24),
                    _StatChip(label: '5', subtitle: 'Promo'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Menu Sections
          _MenuSection(
            title: 'Akun',
            children: [
              _MenuTile(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () {},
              ),
              _MenuTile(
                icon: Icons.receipt_long_rounded,
                title: 'Detail Transaksi',
                onTap: () => context.go('/transaction-detail'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _MenuSection(
            title: 'Layanan',
            children: [
              _MenuTile(
                icon: Icons.location_pin,
                title: 'Monitoring Bengkel',
                onTap: () => context.go('/monitoring'),
              ),
              _MenuTile(
                icon: Icons.local_offer_rounded,
                title: 'Promo Tersimpan',
                onTap: () => context.go('/promo'),
              ),
              _MenuTile(
                icon: Icons.article_rounded,
                title: 'Artikel Otomotif',
                onTap: () => context.go('/article'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _MenuSection(
            title: 'Lainnya',
            children: [
              _MenuTile(
                icon: Icons.notifications_outlined,
                title: 'Notifikasi',
                onTap: () => context.go('/notifications'),
              ),
              _MenuTile(
                icon: Icons.help_outline_rounded,
                title: 'Bantuan',
                onTap: () {},
              ),
              _MenuTile(
                icon: Icons.logout_rounded,
                title: 'Keluar',
                isDestructive: true,
                onTap: () => context.go('/login'),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.subtitle});
  final String label;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDestructive ? Colors.red.shade50 : AppTheme.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : AppTheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? Colors.red : AppTheme.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDestructive ? Colors.red.shade300 : AppTheme.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}