import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/components/promo/promo_offer_card.dart';

class PromoScreen extends StatelessWidget {
  const PromoScreen({super.key});

  static const _promos = [
    _PromoItem(
      title: 'Diskon Servis 25%',
      subtitle: 'Untuk booking home service hari ini',
      tag: 'HOT',
    ),
    _PromoItem(
      title: 'Gratis Cek Mesin',
      subtitle: 'Minimal transaksi Rp 300.000',
      tag: 'NEW',
    ),
    _PromoItem(
      title: 'Cashback 10%',
      subtitle: 'Pembayaran gateway digital tertentu',
      tag: 'LIMITED',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Promo',
      currentIndex: 3,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _promos.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final promo = _promos[index];
          return PromoOfferCard(
            title: promo.title,
            subtitle: promo.subtitle,
            tag: promo.tag,
            onUse: () => context.go('/products'),
          );
        },
      ),
    );
  }
}

class _PromoItem {
  const _PromoItem({
    required this.title,
    required this.subtitle,
    required this.tag,
  });

  final String title;
  final String subtitle;
  final String tag;
}
