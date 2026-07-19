import 'package:flutter/material.dart';
import 'package:shop_and_drive/components/floating/floating_bottom_bar.dart';
import 'package:shop_and_drive/components/navigation/app_tab_navigation.dart';
import 'package:shop_and_drive/core/theme/app_theme.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    this.image,
    required this.body,
    this.currentIndex,
    this.actions,
    this.notificationCount = 2,
    this.useSafeArea = true,
    this.showBackButton = false,
  });

  final String? title;
  final String? image;
  final Widget body;
  final int? currentIndex;
  final List<Widget>? actions;
  final int notificationCount;
  final bool useSafeArea;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final pageBody = useSafeArea ? SafeArea(child: body) : body;

    // Show back button if explicitly requested OR if currentIndex is null (not a bottom bar screen)
    final shouldShowBack = showBackButton || currentIndex == null;

    return Scaffold(
      appBar: title != null || image != null
          ? AppBar(
              leading: shouldShowBack
                  ? IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                      ),
                    )
                  : null,
              title: title != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 28,
                            height: 28,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.directions_car_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    )
                  : (image != null
                      ? Image.asset(image!, height: 36)
                      : null),
              actions: actions,
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,
              shape: const Border(
                bottom: BorderSide(
                  color: Color(0xFFB82436),
                  width: 1,
                ),
              ),
            )
          : null,
      extendBodyBehindAppBar: false,
      body: Stack(children: [const _AppBackgroundDecor(), pageBody]),
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
          colors: [Color(0xFFFDF4F2), Color(0xFFF6F8FB), Color(0xFFF1F6FB)],
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
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.55),
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
              decoration: BoxDecoration(
                color: AppTheme.secondary.withValues(alpha: 0.33),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}