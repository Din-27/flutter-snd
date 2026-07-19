import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/components/floating/floating_search_bar.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/components/swiper/swiper.dart';
import 'package:shop_and_drive/core/theme/app_theme.dart';
import 'package:shop_and_drive/utils/greetings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _bannerItems = [
    BannerSwiperItem(
      imageUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=1200&auto=format&fit=crop',
      title: 'Promo Servis Bulanan',
      subtitle: 'Diskon hingga 25% minggu ini',
    ),
    BannerSwiperItem(
      imageUrl: 'https://images.unsplash.com/photo-1513151233558-d860c5398176?q=80&w=1200&auto=format&fit=crop',
      title: 'Free Checkup Kendaraan',
      subtitle: 'Untuk booking sebelum Jumat',
    ),
    BannerSwiperItem(
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1200&auto=format&fit=crop',
      title: 'Paket Mudik Aman',
      subtitle: 'Mulai dari Rp 299.000',
    ),
  ];

  static const _services = [
    _ServiceItem(icon: Icons.car_repair_rounded, label: 'Service', route: '/monitoring'),
    _ServiceItem(icon: Icons.oil_barrel_rounded, label: 'Ganti Oli', route: '/products'),
    _ServiceItem(icon: Icons.ac_unit_rounded, label: 'AC Mobil', route: '/products'),
    _ServiceItem(icon: Icons.build_circle_rounded, label: 'Sparepart', route: '/products'),
    _ServiceItem(icon: Icons.local_car_wash_rounded, label: 'Cuci Mobil', route: '/products'),
    _ServiceItem(icon: Icons.tire_repair_rounded, label: 'Ban & Velg', route: '/products'),
    _ServiceItem(icon: Icons.electrical_services_rounded, label: 'Aki & Listrik', route: '/products'),
    _ServiceItem(icon: Icons.miscellaneous_services_rounded, label: 'Lainnya', route: '/products'),
  ];

  static const _productItems = [
    ProductSwiperItem(
      name: 'Brake Pad Ceramic', category: 'Sparepart', price: 'Rp 850.000', rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1487754180451-c456f719a1fc?q=80&w=1200&auto=format&fit=crop',
    ),
    ProductSwiperItem(
      name: 'Engine Oil 5W-30', category: 'Oli Mesin', price: 'Rp 420.000', rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?q=80&w=1200&auto=format&fit=crop',
    ),
    ProductSwiperItem(
      name: 'Portable Jump Starter', category: 'Aksesoris', price: 'Rp 1.250.000', rating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1580273916550-e323be2ae537?q=80&w=1200&auto=format&fit=crop',
    ),
  ];

  static const _promoItems = [
    _PromoItem(title: 'Diskon Ganti Oli 30%', description: 'Berlaku hingga akhir bulan',
      imageUrl: 'https://images.unsplash.com/photo-1530046339160-ce3e530c7d2f?q=80&w=600&auto=format&fit=crop', badge: 'HOT'),
    _PromoItem(title: 'Gratis Pengecekan AC', description: 'Setiap hari Senin-Kamis',
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?q=80&w=600&auto=format&fit=crop', badge: 'NEW'),
    _PromoItem(title: 'Paket Service Hemat', description: 'Mulai Rp 199.000',
      imageUrl: 'https://images.unsplash.com/photo-1487754180451-c456f719a1fc?q=80&w=600&auto=format&fit=crop', badge: 'HEMAT'),
  ];

  static const _articleItems = [
    _ArticleItem(title: 'Tips Merawat Mesin Mobil di Musim Hujan', category: 'Tips & Trick', readTime: '5 min',
      imageUrl: 'https://images.unsplash.com/photo-1487754180451-c456f719a1fc?q=80&w=400&auto=format&fit=crop'),
    _ArticleItem(title: '5 Kesalahan Umum Saat Mengemudi', category: 'Safety', readTime: '3 min',
      imageUrl: 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?q=80&w=400&auto=format&fit=crop'),
    _ArticleItem(title: 'Cara Memilih Oli Mesin yang Tepat', category: 'Review', readTime: '4 min',
      imageUrl: 'https://images.unsplash.com/photo-1530046339160-ce3e530c7d2f?q=80&w=400&auto=format&fit=crop'),
  ];

  @override
  Widget build(BuildContext context) {
    final greeting = getGreetingMessage();

    return AppPageScaffold(
      title: null,
      image: 'assets/images/logo.png',
      currentIndex: 0,
      actions: [
        IconButton(
          onPressed: () => context.go('/notifications'),
          icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // Greeting
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppTheme.accent,
                  child: Icon(Icons.person_rounded, color: AppTheme.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$greeting,',
                        style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                      ),
                      const Text(
                        'Herdiyana',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                _PointsBadge(onTap: () => context.go('/promo')),
              ],
            ),
            const SizedBox(height: 16),
            // Search
            FloatingSearchBar(onFilterPressed: () => debugPrint('Search filter tapped')),
            const SizedBox(height: 16),
            // Vehicle Status
            const _VehicleStatusCard(),
            const SizedBox(height: 20),
            // Service Menu Grid (Grab-style)
            const _ServiceMenuGrid(services: _services),
            const SizedBox(height: 20),
            // Banner Carousel
            const AppSwiper.banner(banners: _bannerItems),
            const SizedBox(height: 24),
            // Products
            _SectionHeader(title: 'Produk Pilihan', onTap: () => context.go('/products')),
            const SizedBox(height: 12),
            const AppSwiper.product(products: _productItems),
            const SizedBox(height: 24),
            // Promo
            _SectionHeader(title: 'Promo Spesial', onTap: () => context.go('/promo')),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _promoItems.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, index) => _PromoCard(promo: _promoItems[index]),
              ),
            ),
            const SizedBox(height: 24),
            // Articles
            _SectionHeader(title: 'Artikel Terbaru', onTap: () => context.go('/article')),
            const SizedBox(height: 12),
            ..._articleItems.map((article) => _ArticleCard(article: article)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ==================== Points Badge ====================

class _PointsBadge extends StatelessWidget {
  const _PointsBadge({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.accent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.stars_rounded, color: AppTheme.primary, size: 18),
            const SizedBox(width: 4),
            Text(
              '2.450 Pts',
              style: TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== Section Header ====================

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Text('Lihat Semua', style: TextStyle(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.w600)),
              Icon(Icons.chevron_right, size: 18, color: AppTheme.primary),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== Service Menu Grid ====================

class _ServiceMenuGrid extends StatelessWidget {
  const _ServiceMenuGrid({required this.services});
  final List<_ServiceItem> services;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EBF1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return _ServiceIcon(service: service);
        },
      ),
    );
  }
}

class _ServiceIcon extends StatelessWidget {
  const _ServiceIcon({required this.service});
  final _ServiceItem service;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(service.route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
          decoration: BoxDecoration(
            color: AppTheme.accent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.1)),
          ),
            child: Icon(service.icon, color: AppTheme.primary, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            service.label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ==================== Vehicle Status Card ====================

class _VehicleStatusCard extends StatelessWidget {
  const _VehicleStatusCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.primary,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.directions_car_rounded, size: 32, color: Colors.white),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Toyota Supra', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 4),
                Text('Due for service in 10 days', style: TextStyle(fontSize: 13, color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () => context.go('/products'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Book', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ==================== Promo Card ====================

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.promo});
  final _PromoItem promo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/promo'),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
          ],
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
                    height: 88,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      height: 88,
                      color: AppTheme.accent,
                      child: const Icon(Icons.local_offer_rounded, color: AppTheme.primary, size: 32),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(promo.badge, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(promo.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(promo.description, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== Article Card ====================

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});
  final _ArticleItem article;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/article/1'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  article.imageUrl,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 72, height: 72, color: AppTheme.accent,
                    child: const Icon(Icons.article_rounded, color: AppTheme.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(6)),
                            child: Text(article.category,
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.primary)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.access_time, size: 12, color: AppTheme.textSecondary),
                        const SizedBox(width: 3),
                        Text(article.readTime, style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(article.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 20, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== Data Models ====================

class _ServiceItem {
  const _ServiceItem({required this.icon, required this.label, required this.route});
  final IconData icon;
  final String label;
  final String route;
}

class _PromoItem {
  const _PromoItem({required this.title, required this.description, required this.imageUrl, required this.badge});
  final String title;
  final String description;
  final String imageUrl;
  final String badge;
}

class _ArticleItem {
  const _ArticleItem({required this.title, required this.category, required this.readTime, required this.imageUrl});
  final String title;
  final String category;
  final String readTime;
  final String imageUrl;
}