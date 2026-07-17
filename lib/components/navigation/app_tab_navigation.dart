import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class AppTabNavigation {
  static void onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/products');
        break;
      case 2:
        context.go('/monitoring');
        break;
      case 3:
        context.go('/promo');
        break;
      case 4:
        context.go('/profile');
        break;
      default:
        context.go('/');
    }
  }
}
