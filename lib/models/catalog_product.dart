class CatalogProduct {
  const CatalogProduct({
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });

  final String name;
  final String category;
  final int price;
  final String imageUrl;
  final double rating;
}
