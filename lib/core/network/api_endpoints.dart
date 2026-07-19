class ApiEndpoints {
  static const baseUrl = 'http://localhost:3000/api/customer';

  // Auth
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const profile = '/profile';

  // Products
  static const products = '/products';
  static String productDetail(String id) => '/products/$id';

  // Promos & Banners
  static const promos = '/promos';
  static const banners = '/banners';

  // Workshops
  static const workshops = '/workshops';

  // Orders
  static const orders = '/orders';
  static String orderDetail(String id) => '/orders/$id';

  // Tracking
  static String tracking(String orderId) => '/tracking/$orderId';
}
