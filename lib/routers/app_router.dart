import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/screens/homepage.dart';

class DetailScreen extends StatelessWidget {
  final String id;
  const DetailScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Detail ID: $id')));
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) {
        final productId = state.pathParameters['id'] ?? '';
        return DetailScreen(id: productId);
      },
    ),
  ],
);
