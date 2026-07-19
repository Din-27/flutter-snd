import 'package:flutter/material.dart';
import 'package:shop_and_drive/models/api_models.dart';

class ProductGridCard extends StatelessWidget {
  const ProductGridCard({
    super.key,
    required this.product,
    required this.priceText,
    required this.onTap,
  });

  final ProductResponse product;
  final String priceText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  product.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: double.infinity,
                    color: const Color(0xFFF5F5F5),
                    child: Image.asset(
                      'assets/images/default_product.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => const Icon(Icons.inventory_2_rounded, color: Colors.grey, size: 40),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${product.category}  |  ${product.rating.toStringAsFixed(1)}★',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF6D6A69)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    priceText,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}