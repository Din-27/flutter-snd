import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/core/di/app_services.dart';
import 'package:shop_and_drive/core/theme/app_theme.dart';
import 'package:shop_and_drive/models/api_models.dart';
import 'package:shop_and_drive/utils/toast.dart';

class PromoScreen extends StatefulWidget {
  const PromoScreen({super.key});

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  List<PromoResponse> _promos = [];
  bool _loading = true;

  static const _fallbackPromos = [
    _PromoData(title: 'Diskon Servis 25%', subtitle: 'Untuk booking home service hari ini', tag: 'HOT',
      imageUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=600&auto=format&fit=crop', validUntil: '31 Jul 2026'),
    _PromoData(title: 'Gratis Cek Mesin', subtitle: 'Minimal transaksi Rp 300.000', tag: 'NEW',
      imageUrl: 'https://images.unsplash.com/photo-1487754180451-c456f719a1fc?q=80&w=600&auto=format&fit=crop', validUntil: '15 Agu 2026'),
    _PromoData(title: 'Cashback 10%', subtitle: 'Pembayaran gateway digital tertentu', tag: 'LIMITED',
      imageUrl: 'https://images.unsplash.com/photo-1530046339160-ce3e530c7d2f?q=80&w=600&auto=format&fit=crop', validUntil: '20 Jul 2026'),
    _PromoData(title: 'Paket Ganti Oli', subtitle: 'Hemat Rp 150.000 untuk paket lengkap', tag: 'HEMAT',
      imageUrl: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?q=80&w=600&auto=format&fit=crop', validUntil: '10 Agu 2026'),
  ];

  @override
  void initState() {
    super.initState();
    _loadPromos();
  }

  Future<void> _loadPromos() async {
    final result = await AppServices.promoRepository.fetchPromos();
    if (mounted) {
      result.when(
        success: (promos) => setState(() { _promos = promos; _loading = false; }),
        failure: (_) => setState(() => _loading = false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _promos.isNotEmpty
        ? _promos.map((p) => _PromoData(
              title: p.title,
              subtitle: p.description,
              tag: 'PROMO',
              imageUrl: p.imageUrl,
              validUntil: p.endDate ?? 'Segera',
            )).toList()
        : _fallbackPromos;

    return AppPageScaffold(
      title: 'Promo',
      currentIndex: null,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final promo = items[index];
                return _PromoCard(promo: promo, onUse: () {
                  showToast(context, 'Promo "${promo.title}" berhasil digunakan!');
                  context.go('/products');
                });
              },
            ),
    );
  }
}

class _PromoData {
  const _PromoData({required this.title, required this.subtitle, required this.tag, required this.imageUrl, required this.validUntil});
  final String title;
  final String subtitle;
  final String tag;
  final String imageUrl;
  final String validUntil;
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.promo, required this.onUse});
  final _PromoData promo;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  promo.imageUrl,
                  height: 140, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 140, color: AppTheme.accent,
                    child: const Icon(Icons.local_offer_rounded, color: AppTheme.primary, size: 48),
                  ),
                ),
              ),
              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: promo.tag == 'HOT' ? Colors.red : AppTheme.primary,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Text(promo.tag, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(promo.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(promo.subtitle, style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Icon(Icons.schedule, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text('Berlaku hingga ${promo.validUntil}', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    ]),
                    FilledButton(
                      onPressed: onUse,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary, foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Pakai', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}