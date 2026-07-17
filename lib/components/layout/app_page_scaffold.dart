import 'package:flutter/material.dart';
import 'package:shop_and_drive/components/floating/floating_bottom_bar.dart';
import 'package:shop_and_drive/components/navigation/app_tab_navigation.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.currentIndex,
    this.actions,
    this.notificationCount = 2,
    this.useSafeArea = true,
  });

  final String title;
  final Widget body;
  final int? currentIndex;
  final List<Widget>? actions;
  final int notificationCount;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final pageBody = useSafeArea ? SafeArea(child: body) : body;

    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      extendBodyBehindAppBar: false,
      body: Stack(
        children: [
          const _AppBackgroundDecor(),
          pageBody,
        ],
      ),
      bottomNavigationBar: currentIndex == null
          ? null
          : FloatingBottomBar(
              currentIndex: currentIndex!,
              notificationCount: notificationCount,
              onTap: (index) => AppTabNavigation.onTap(context, index),
            ),
    );
  }
}

class _AppBackgroundDecor extends StatelessWidget {
  const _AppBackgroundDecor();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFDF4F2),
            Color(0xFFF6F8FB),
            Color(0xFFF1F6FB),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -70,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                color: Color.fromARGB(140, 255, 240, 238),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -60,
            bottom: -90,
            child: Container(
              width: 240,
              height: 240,
              decoration: const BoxDecoration(
                color: Color.fromARGB(85, 201, 224, 240),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
