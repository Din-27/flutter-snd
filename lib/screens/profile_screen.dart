import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/core/di/app_services.dart';
import 'package:shop_and_drive/core/theme/app_theme.dart';
import 'package:shop_and_drive/models/api_models.dart';
import 'package:shop_and_drive/utils/toast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CustomerProfileResponse? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final result = await AppServices.authRepository.getProfile();
    if (mounted) {
      result.when(
        success: (profile) => setState(() { _profile = profile; _loading = false; }),
        failure: (_) => setState(() => _loading = false),
      );
    }
  }

  String get _name => _profile?.name ?? 'Herdiyana';
  String get _email => _profile?.email ?? 'herdiyana@example.com';
  String get _points => '2.450';
  int get _transactionCount => 12;
  int get _promoCount => 5;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Profile',
      currentIndex: 4,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : ListView(
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
                      Text(
                        _name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _email,
                        style: const TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _StatChip(label: _points, subtitle: 'Poin'),
                          const SizedBox(width: 24),
                          _StatChip(label: '$_transactionCount', subtitle: 'Transaksi'),
                          const SizedBox(width: 24),
                          _StatChip(label: '$_promoCount', subtitle: 'Promo'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _MenuSection(
                  title: 'Akun',
                  children: [
                    _MenuTile(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      onTap: () => _showEditProfileDialog(context),
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
                      icon: Icons.shopping_cart_rounded,
                      title: 'Keranjang',
                      onTap: () => context.go('/cart'),
                    ),
                    _MenuTile(
                      icon: Icons.location_pin,
                      title: 'Peta Bengkel',
                      onTap: () => context.go('/workshop-map'),
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
                      onTap: () => showToast(context, 'Hubungi CS: support@shopanddrive.id'),
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

  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: _name);
    final emailController = TextEditingController(text: _email);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama', border: OutlineInputBorder()),
                validator: (v) => v == null || v.trim().isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || v.trim().isEmpty ? 'Email tidak boleh kosong' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx);
                final result = await AppServices.authRepository.updateProfile(
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                );
                if (mounted) {
                  result.when(
                    success: (_) {
                      showToast(context, 'Profile berhasil diupdate');
                      _loadProfile();
                    },
                    failure: (error) => showToast(context, error),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, letterSpacing: 0.5),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.title, required this.onTap, this.isDestructive = false});
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
              child: Icon(icon, color: isDestructive ? Colors.red : AppTheme.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w500, color: isDestructive ? Colors.red : AppTheme.textPrimary),
              ),
            ),
            Icon(Icons.chevron_right, color: isDestructive ? Colors.red.shade300 : AppTheme.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}