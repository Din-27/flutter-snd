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

class _DetailScreen extends StatelessWidget {
  final String id;
  const _DetailScreen({required this.id});

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Detail ID: $id')));
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
      path: '/detail/:id',
      builder: (context, state) {
        final productId = state.pathParameters['id'] ?? '';
        return _DetailScreen(id: productId);
      },
    ),
  ],
);
