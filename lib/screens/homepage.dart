import 'package:flutter/material.dart';
import 'package:shop_and_drive/components/floating/floating_app_bar.dart';
import 'package:shop_and_drive/components/floating/floating_bottom_bar.dart';
import 'package:shop_and_drive/components/floating/floating_search_bar.dart';
import 'package:shop_and_drive/components/swiper/swiper.dart';
import 'package:shop_and_drive/utils/greetings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _primaryColor = Color.fromARGB(255, 196, 39, 39);
  static const _cardBorderColor = Color.fromARGB(255, 221, 172, 159);
  static const _cardBackgroundColor = Color.fromARGB(137, 240, 183, 165);

  @override
  Widget build(BuildContext context) {
    final greeting = getGreetingMessage();

    return Scaffold(
      appBar: FloatingAppBar(
        onFilterPressed: () {
          debugPrint('Notification tapped');
        },
      ),
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
            const SumbawaBannerSwiper(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('Menu Utama atau Konten Lainnya...'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FloatingBottomBar(
        currentIndex: 0,
        notificationCount: 2,
        onTap: (index) {
          debugPrint('Bottom bar tapped: $index');
        },
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
