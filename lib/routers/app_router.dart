import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/core/di/app_services.dart';
import 'package:shop_and_drive/screens/checkout_screen.dart';
import 'package:shop_and_drive/screens/homepage.dart';
import 'package:shop_and_drive/screens/login_screen.dart';
import 'package:shop_and_drive/screens/workshop_map_screen.dart';
import 'package:shop_and_drive/screens/notification_screen.dart';
import 'package:shop_and_drive/screens/product_screen.dart';
import 'package:shop_and_drive/screens/profile_screen.dart';
import 'package:shop_and_drive/screens/promo_screen.dart';
import 'package:shop_and_drive/screens/register_screen.dart';
import 'package:shop_and_drive/screens/splash_screen.dart';
import 'package:shop_and_drive/screens/transaction_detail_screen.dart';
import 'package:shop_and_drive/screens/article_screen.dart';
import 'package:shop_and_drive/screens/cart_screen.dart';
import 'package:shop_and_drive/screens/product_detail_screen.dart';
import 'package:shop_and_drive/screens/otp_screen.dart';

class _ArticleDetailScreen extends StatelessWidget {
  final String articleId;
  const _ArticleDetailScreen({required this.articleId});

  static const _articles = {
    '1': (
      title: 'Tips Merawat Mesin Mobil di Musim Hujan',
      category: 'Tips & Trick',
      readTime: '5 min',
      imageUrl: 'https://images.unsplash.com/photo-1487754180451-c456f719a1fc?q=80&w=800&auto=format&fit=crop',
      content: 'Musim hujan bisa menjadi tantangan tersendiri untuk perawatan mobil. '
          'Air hujan yang mengandung asam dapat merusak cat dan komponen metal kendaraan. '
          'Berikut tips untuk menjaga mesin tetap prima selama musim hujan:\n\n'
          '1. Cuci mobil secara rutin\n'
          '2. Periksa kondisi wiper\n'
          '3. Pastikan AC berfungsi dengan baik\n'
          '4. Cek kondisi ban dan rem\n'
          '5. Gunakan cover mobil saat parkir\n\n'
          'Dengan perawatan yang tepat, mobil Anda akan tetap dalam kondisi prima '
          'meski digunakan dalam kondisi cuaca yang tidak menentu.',
    ),
    '2': (
      title: '5 Kesalahan Umum Saat Mengemudi',
      category: 'Safety',
      readTime: '3 min',
      imageUrl: 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?q=80&w=800&auto=format&fit=crop',
      content: 'Kesalahan saat mengemudi bisa berakibat fatal. Berikut 5 kesalahan umum yang sering dilakukan:\n\n'
          '1. Tidak menggunakan sabuk pengaman\n'
          '2. Menggunakan ponsel saat berkendara\n'
          '3. Tidak memerikkan spion sebelum pindah jalur\n'
          '4. Mengemudi dalam keadaan lelah\n'
          '5. Tidak menjaga jarak aman\n\n'
          'Hindari kesalahan-kesalahan ini untuk keselamatan Anda dan pengguna jalan lainnya.',
    ),
    '3': (
      title: 'Cara Memilih Oli Mesin yang Tepat',
      category: 'Review',
      readTime: '4 min',
      imageUrl: 'https://images.unsplash.com/photo-1530046339160-ce3e530c7d2f?q=80&w=800&auto=format&fit=crop',
      content: 'Pemilihan oli mesin yang tepat sangat penting untuk performa dan umur mesin. '
          'Berikut panduan memilih oli mesin:\n\n'
          '1. Perhatikan viskositas (SAE) sesuai rekomendasi pabrikan\n'
          '2. Pilih kualitas API yang sesuai\n'
          '3. Pertimbangkan kondisi iklim dan penggunaan\n'
          '4. Gunakan oli original dari merek terpercaya\n'
          '5. Ganti oli secara berkala sesuai interval\n\n'
          'Oli yang tepat akan menjaga mesin tetap halus dan efisien.',
    ),
    '4': (
      title: 'Tanda-tanda Aki Mobil Harus Diganti',
      category: 'Tips & Trick',
      readTime: '4 min',
      imageUrl: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?q=80&w=800&auto=format&fit=crop',
      content: 'Aki yang melemah bisa menyebabkan mobil tidak bisa distarter. Kenali tanda-tandanya:\n\n'
          '1. Mesin susah distarter\n'
          '2. Lampu dashboard redup saat mesin mati\n'
          '3. Aki bengkak atau berbau\n'
          '4. Usia aki sudah lebih dari 2 tahun\n'
          '5. Voltmeter menunjukkan di bawah 12V\n\n'
          'Ganti aki sebelum benar-benar mati untuk menghindari masalah di jalan.',
    ),
    '5': (
      title: 'Panduan Lengkap Service Berkala',
      category: 'Tips & Trick',
      readTime: '6 min',
      imageUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=800&auto=format&fit=crop',
      content: 'Service berkala adalah kunci menjaga performa kendaraan. Berikut jadwal service:\n\n'
          '• 1.000 km: Pengecekan awal\n'
          '• 5.000 km: Ganti oli dan filter\n'
          '• 10.000 km: Service ringan\n'
          '• 20.000 km: Service sedang\n'
          '• 40.000 km: Service besar\n\n'
          'Ikuti jadwal service untuk performa optimal dan umur kendaraan yang panjang.',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final article = _articles[articleId] ?? _articles['1']!;

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
                article.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 200,
                  color: const Color(0xFFFFF0EE),
                  child: const Icon(Icons.article_rounded, color: Color(0xFFCE2939), size: 48),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0EE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                article.category,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFCE2939)),
              ),
            ),
            const SizedBox(height: 12),
            Text(article.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${article.readTime} read', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 20),
            Text(article.content, style: const TextStyle(fontSize: 15, height: 1.6)),
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
    final isAuthRoute = state.fullPath == '/login' || state.fullPath == '/register' || state.fullPath == '/otp';
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
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final phone = state.uri.queryParameters['phone'] ?? '';
        return OTPScreen(phone: phone);
      },
    ),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(
      path: '/products',
      builder: (context, state) {
        final category = state.uri.queryParameters['category'];
        return ProductScreen(initialCategory: category);
      },
    ),
    GoRoute(
      path: '/workshop-map',
      builder: (context, state) => const WorkshopMapScreen(),
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
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
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
      builder: (context, state) => const TransactionDetailScreen(),
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
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) {
        final productId = state.pathParameters['id'] ?? '';
        return ProductDetailScreen(productId: productId);
      },
    ),
  ],
);
