import 'package:flutter/material.dart';
import 'package:shop_and_drive/models/catalog_product.dart';

class ProductListCard extends StatelessWidget {
  const ProductListCard({
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
      child: Row(
        children: [
          SizedBox(
            width: 110,
            height: 110,
            child: Image.network(product.imageUrl, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(
                    '${product.category}  |  ${product.rating.toStringAsFixed(1)}★',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6D6A69)),
                  ),
                  const SizedBox(height: 7),
                  Text(priceText, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 7),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton(onPressed: onCheckout, child: const Text('Checkout')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
