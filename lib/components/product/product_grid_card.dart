import 'package:flutter/material.dart';
import 'package:shop_and_drive/models/catalog_product.dart';

class ProductGridCard extends StatelessWidget {
  const ProductGridCard({
    super.key,
    required this.product,
    required this.priceText,
    required this.onCheckout,
  });

  final CatalogProduct product;
  final String priceText;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  '${product.category}  |  ${product.rating.toStringAsFixed(1)}★',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6D6A69)),
                ),
                const SizedBox(height: 6),
                Text(priceText, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(onPressed: onCheckout, child: const Text('Checkout')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
