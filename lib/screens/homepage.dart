import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/components/floating/floating_app_bar.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/components/floating/floating_search_bar.dart';
import 'package:shop_and_drive/components/swiper/swiper.dart';
import 'package:shop_and_drive/utils/greetings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _primaryColor = Color(0xFFFFF0EE);
  static const _cardBorderColor = Color.fromARGB(255, 221, 172, 159);
  static const _cardBackgroundColor = Color.fromARGB(137, 240, 183, 165);

  static const _bannerItems = [
    BannerSwiperItem(
      imageUrl:
          'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=1200&auto=format&fit=crop',
      title: 'Promo Servis Bulanan',
      subtitle: 'Diskon hingga 25% minggu ini',
    ),
    BannerSwiperItem(
      imageUrl:
          'https://images.unsplash.com/photo-1513151233558-d860c5398176?q=80&w=1200&auto=format&fit=crop',
      title: 'Free Checkup Kendaraan',
      subtitle: 'Untuk booking sebelum Jumat',
    ),
    BannerSwiperItem(
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1200&auto=format&fit=crop',
      title: 'Paket Mudik Aman',
      subtitle: 'Mulai dari Rp 299.000',
    ),
  ];

  static const _productItems = [
    ProductSwiperItem(
      name: 'Brake Pad Ceramic',
      category: 'Sparepart',
      price: 'Rp 850.000',
      rating: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1487754180451-c456f719a1fc?q=80&w=1200&auto=format&fit=crop',
    ),
    ProductSwiperItem(
      name: 'Engine Oil 5W-30',
      category: 'Oli Mesin',
      price: 'Rp 420.000',
      rating: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1635764702449-71f3fb13f346?q=80&w=1200&auto=format&fit=crop',
    ),
    ProductSwiperItem(
      name: 'Portable Jump Starter',
      category: 'Aksesoris',
      price: 'Rp 1.250.000',
      rating: 4.9,
      imageUrl:
          'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?q=80&w=1200&auto=format&fit=crop',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final greeting = getGreetingMessage();

    return AppPageScaffold(
      title: 'Shop & Drive',
      currentIndex: 0,
      actions: [
        IconButton(
          onPressed: () => context.go('/notifications'),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Row(
              children: [
                Text(
                  '$greeting, ',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Herdiyana',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FloatingSearchBar(
              onFilterPressed: () {
                debugPrint('Search filter tapped');
              },
            ),
            const SizedBox(height: 12),
            const _VehicleStatusCard(
              primaryColor: _primaryColor,
              borderColor: _cardBorderColor,
              backgroundColor: _cardBackgroundColor,
            ),
            const SizedBox(height: 20),
            _MonitoringShortcut(
              onPressed: () {
                context.go('/monitoring');
              },
            ),
            const SizedBox(height: 20),
            const AppSwiper.banner(banners: _bannerItems),
            const SizedBox(height: 20),
            const Text(
              'Produk Pilihan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const AppSwiper.product(products: _productItems),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('Geser untuk melihat produk lainnya...'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonitoringShortcut extends StatelessWidget {
  const _MonitoringShortcut({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFF8F4F4),
        border: Border.all(color: const Color(0xFFE4D9D7)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF0EE),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.map_rounded, color: Color(0xFF6A5551)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monitoring Bengkel Terdekat',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 2),
                Text(
                  'Cek bengkel terdekat dan perjalanan home service secara live.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6D6A69)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFFF0EE),
              foregroundColor: const Color(0xFF5C4E4B),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            child: const Text('Buka'),
          ),
        ],
      ),
    );
  }
}

class _VehicleStatusCard extends StatelessWidget {
  const _VehicleStatusCard({
    required this.primaryColor,
    required this.borderColor,
    required this.backgroundColor,
  });

  final Color primaryColor;
  final Color borderColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        color: backgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: CircleAvatar(
              minRadius: 30,
              maxRadius: 30,
              backgroundColor: primaryColor,
              child: const Icon(
                Icons.directions_car,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Toyota Supra',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Text(
                  'Due for service in 10 days',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
