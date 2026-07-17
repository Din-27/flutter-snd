class ApiEndpoints {
  static const baseUrl = 'https://api.example.com';

  static const login = '/auth/login';
  static const register = '/auth/register';
  static const refreshToken = '/auth/refresh-token';

  static const products = '/products';
  static const productDetail = '/products/{id}';

  static const createPayment = '/payments/create';
  static const paymentStatus = '/payments/{id}/status';
}
