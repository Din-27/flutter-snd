import 'package:shop_and_drive/core/network/api_exception.dart';

class GlobalErrorHandler {
  static String toUserMessage(Object error) {
    if (error is ApiException) {
      if (error.statusCode == 401) {
        return 'Sesi Anda berakhir. Silakan login kembali.';
      }
      return error.message;
    }

    return 'Terjadi kesalahan. Silakan coba lagi.';
  }
}
