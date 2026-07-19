import 'package:flutter/material.dart';
import 'package:shop_and_drive/models/api_models.dart';

class ProductListCard extends StatelessWidget {
  const ProductListCard({
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
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              child: Image.network(
                product.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 100,
                  height: 100,
                  color: const Color(0xFFF5F5F5),
                  child: Image.asset(
                    'assets/images/default_product.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Icon(Icons.inventory_2_rounded, color: Colors.grey, size: 40),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.category}  |  ${product.rating.toStringAsFixed(1)}★',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF6D6A69)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      priceText,
                      style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}