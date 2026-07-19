// ==================== Auth Models ====================

class CustomerProfileResponse {
  final String userId;
  final String name;
  final String email;

  const CustomerProfileResponse({
    required this.userId,
    required this.name,
    required this.email,
  });

  factory CustomerProfileResponse.fromJson(Map<String, dynamic> json) {
    return CustomerProfileResponse(
      userId: json['userId']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}

class AuthTokenResponse {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String name;
  final String email;

  const AuthTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.name,
    required this.email,
  });

  factory AuthTokenResponse.fromJson(Map<String, dynamic> json) {
    return AuthTokenResponse(
      accessToken: json['accessToken']?.toString() ?? json['token']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      userId: json['userId']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}

// ==================== Product Models ====================

class ProductResponse {
  final String id;
  final String name;
  final String category;
  final int price;
  final String imageUrl;
  final double rating;
  final String? merchantId;
  final String? merchantName;

  const ProductResponse({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.rating,
    this.merchantId,
    this.merchantName,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: _parseInt(json['price']),
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
      rating: _parseDouble(json['rating']),
      merchantId: json['merchantId']?.toString(),
      merchantName: json['merchantName']?.toString() ?? json['merchant']?['name']?.toString(),
    );
  }
}

class ProductDetailResponse {
  final String id;
  final String name;
  final String category;
  final int price;
  final String imageUrl;
  final double rating;
  final String? description;
  final String? merchantId;
  final String? merchantName;
  final String? merchantAddress;

  const ProductDetailResponse({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.rating,
    this.description,
    this.merchantId,
    this.merchantName,
    this.merchantAddress,
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponse(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: _parseInt(json['price']),
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
      rating: _parseDouble(json['rating']),
      description: json['description']?.toString(),
      merchantId: json['merchantId']?.toString(),
      merchantName: json['merchantName']?.toString() ?? json['merchant']?['name']?.toString(),
      merchantAddress: json['merchantAddress']?.toString() ?? json['merchant']?['address']?.toString(),
    );
  }
}

// ==================== Promo Models ====================

class PromoResponse {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String? startDate;
  final String? endDate;

  const PromoResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.startDate,
    this.endDate,
  });

  factory PromoResponse.fromJson(Map<String, dynamic> json) {
    return PromoResponse(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
      startDate: json['startDate']?.toString(),
      endDate: json['endDate']?.toString(),
    );
  }
}

class BannerResponse {
  final String id;
  final String title;
  final String? subtitle;
  final String imageUrl;
  final String? position;

  const BannerResponse({
    required this.id,
    required this.title,
    this.subtitle,
    required this.imageUrl,
    this.position,
  });

  factory BannerResponse.fromJson(Map<String, dynamic> json) {
    return BannerResponse(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
      position: json['position']?.toString(),
    );
  }
}

// ==================== Workshop Models ====================

class WorkshopResponse {
  final String id;
  final String name;
  final String address;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? status;

  const WorkshopResponse({
    required this.id,
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.status,
  });

  factory WorkshopResponse.fromJson(Map<String, dynamic> json) {
    return WorkshopResponse(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      latitude: _parseDoubleNullable(json['latitude']),
      longitude: _parseDoubleNullable(json['longitude']),
      phone: json['phone']?.toString(),
      status: json['status']?.toString(),
    );
  }
}

// ==================== Order Models ====================

class OrderResponse {
  final String id;
  final String status;
  final int totalAmount;
  final String? createdAt;
  final List<OrderItemResponse>? items;

  const OrderResponse({
    required this.id,
    required this.status,
    required this.totalAmount,
    this.createdAt,
    this.items,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      totalAmount: _parseInt(json['totalAmount'] ?? json['total']),
      createdAt: json['createdAt']?.toString(),
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => OrderItemResponse.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

class OrderItemResponse {
  final String productId;
  final String productName;
  final int price;
  final int quantity;

  const OrderItemResponse({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) {
    return OrderItemResponse(
      productId: json['productId']?.toString() ?? json['product']?.toString() ?? '',
      productName: json['productName']?.toString() ?? json['name']?.toString() ?? '',
      price: _parseInt(json['price']),
      quantity: _parseInt(json['quantity']),
    );
  }
}

class CreateOrderRequest {
  final List<CreateOrderItemRequest> items;

  const CreateOrderRequest({required this.items});

  Map<String, dynamic> toJson() => {
        'items': items.map((e) => e.toJson()).toList(),
      };
}

class CreateOrderItemRequest {
  final String productId;
  final int quantity;

  const CreateOrderItemRequest({
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantity': quantity,
      };
}

// ==================== Tracking Models ====================

class TrackingResponse {
  final String orderId;
  final String status;
  final double? latitude;
  final double? longitude;
  final List<TrackingHistoryItem>? history;

  const TrackingResponse({
    required this.orderId,
    required this.status,
    this.latitude,
    this.longitude,
    this.history,
  });

  factory TrackingResponse.fromJson(Map<String, dynamic> json) {
    return TrackingResponse(
      orderId: json['orderId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      latitude: _parseDoubleNullable(json['latitude'] ?? json['lat']),
      longitude: _parseDoubleNullable(json['longitude'] ?? json['lng'] ?? json['lon']),
      history: json['history'] != null
          ? (json['history'] as List)
              .map((e) => TrackingHistoryItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

class TrackingHistoryItem {
  final String status;
  final String? description;
  final String? timestamp;

  const TrackingHistoryItem({
    required this.status,
    this.description,
    this.timestamp,
  });

  factory TrackingHistoryItem.fromJson(Map<String, dynamic> json) {
    return TrackingHistoryItem(
      status: json['status']?.toString() ?? '',
      description: json['description']?.toString(),
      timestamp: json['timestamp']?.toString() ?? json['createdAt']?.toString(),
    );
  }
}

// ==================== Helpers ====================

int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _parseDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

double? _parseDoubleNullable(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}