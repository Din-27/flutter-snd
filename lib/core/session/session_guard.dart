import 'package:flutter/foundation.dart';

class SessionGuard extends ChangeNotifier {
  bool _unauthorized = false;

  bool get unauthorized => _unauthorized;

  void markUnauthorized() {
    _unauthorized = true;
    notifyListeners();
  }

  void clearUnauthorized() {
    if (!_unauthorized) return;
    _unauthorized = false;
    notifyListeners();
  }
}
