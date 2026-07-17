class BannerSwiperItem {
  const BannerSwiperItem({
    required this.imageUrl,
    this.title,
    this.subtitle,
  });

  final String imageUrl;
  final String? title;
  final String? subtitle;
}

class ProductSwiperItem {
  const ProductSwiperItem({
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });

  final String name;
  final String category;
  final String price;
  final double rating;
  final String imageUrl;
}
