import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/core/di/app_services.dart';
import 'package:shop_and_drive/screens/checkout_screen.dart';
import 'package:shop_and_drive/screens/homepage.dart';
import 'package:shop_and_drive/screens/login_screen.dart';
import 'package:shop_and_drive/screens/monitoring_screen.dart';
import 'package:shop_and_drive/screens/notification_screen.dart';
import 'package:shop_and_drive/screens/product_screen.dart';
import 'package:shop_and_drive/screens/profile_screen.dart';
import 'package:shop_and_drive/screens/promo_screen.dart';
import 'package:shop_and_drive/screens/register_screen.dart';
import 'package:shop_and_drive/screens/splash_screen.dart';
import 'package:shop_and_drive/screens/transaction_detail_screen.dart';
import 'package:shop_and_drive/screens/article_screen.dart';
import 'package:shop_and_drive/screens/product_detail_screen.dart';

class _ArticleDetailScreen extends StatelessWidget {
  final String articleId;
  const _ArticleDetailScreen({required this.articleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel'),
        backgroundColor: const Color(0xFFCE2939),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://images.unsplash.com/photo-1487754180451-c456f719a1fc?q=80&w=800&auto=format&fit=crop',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0EE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Tips & Trick', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFCE2939))),
            ),
            const SizedBox(height: 12),
            const Text('Tips Merawat Mesin Mobil di Musim Hujan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('5 min read', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Musim hujan bisa menjadi tantangan tersendiri untuk perawatan mobil. '
              'Air hujan yang mengandung asam dapat merusak cat dan komponen metal kendaraan. '
              'Berikut tips untuk menjaga mesin tetap prima selama musim hujan:\n\n'
              '1. Cuci mobil secara rutin\n'
              '2. Periksa kondisi wiper\n'
              '3. Pastikan AC berfungsi dengan baik\n'
              '4. Cek kondisi ban dan rem\n'
              '5. Gunakan cover mobil saat parkir\n\n'
              'Dengan perawatan yang tepat, mobil Anda akan tetap dalam kondisi prima '
              'meski digunakan dalam kondisi cuaca yang tidak menentu.',
              style: TextStyle(fontSize: 15, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  refreshListenable: AppServices.sessionGuard,
  redirect: (context, state) {
    final isAuthRoute = state.fullPath == '/login' || state.fullPath == '/register';
    final isSplash = state.fullPath == '/splash';

    if (AppServices.sessionGuard.unauthorized && !isAuthRoute) {
      return '/login';
    }

    if (isAuthRoute && !AppServices.sessionGuard.unauthorized) {
      return null;
    }

    if (isSplash) {
      return null;
    }

    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/notifications', builder: (context, state) => const NotificationScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/products', builder: (context, state) => const ProductScreen()),
    GoRoute(
      path: '/monitoring',
      builder: (context, state) => const MonitoringScreen(),
    ),
    GoRoute(path: '/promo', builder: (context, state) => const PromoScreen()),
    GoRoute(path: '/article', builder: (context, state) => const ArticleScreen()),
    GoRoute(
      path: '/article/:id',
      builder: (context, state) {
        final articleId = state.pathParameters['id'] ?? '1';
        return _ArticleDetailScreen(articleId: articleId);
      },
    ),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(
      path: '/checkout',
      builder: (context, state) {
        final product = state.uri.queryParameters['product'] ?? 'Brake Pad Ceramic';
        final amount = int.tryParse(state.uri.queryParameters['amount'] ?? '') ?? 850000;

        return CheckoutScreen(productName: product, amount: amount);
      },
    ),
    GoRoute(
      path: '/transaction-detail',
      builder: (context, state) {
        final orderId = state.uri.queryParameters['orderId'] ?? 'INV-20260717-0001';
        final gateway = state.uri.queryParameters['gateway'] ?? 'Midtrans';
        final amount = int.tryParse(state.uri.queryParameters['amount'] ?? '') ?? 850000;

        return TransactionDetailScreen(
          orderId: orderId,
          gateway: gateway,
          amount: amount,
        );
      },
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final name = state.uri.queryParameters['name'] ?? 'Produk';
        final category = state.uri.queryParameters['category'] ?? 'Sparepart';
        final price = int.tryParse(state.uri.queryParameters['price'] ?? '') ?? 850000;
        final imageUrl = state.uri.queryParameters['image'] ?? '';
        final rating = double.tryParse(state.uri.queryParameters['rating'] ?? '') ?? 4.5;

        return ProductDetailScreen(
          name: name,
          category: category,
          price: price,
          imageUrl: imageUrl,
          rating: rating,
        );
      },
    ),
  ],
);
