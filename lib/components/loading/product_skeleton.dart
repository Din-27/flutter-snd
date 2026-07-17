import 'package:flutter/material.dart';

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
      itemCount: itemCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: [
              Expanded(
                child: Container(color: const Color(0xFFEAEFF5), width: double.infinity),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    _SkeletonLine(widthFactor: 0.8),
                    SizedBox(height: 6),
                    _SkeletonLine(widthFactor: 0.55),
                    SizedBox(height: 10),
                    _SkeletonLine(widthFactor: 0.45),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 11,
        decoration: BoxDecoration(
          color: const Color(0xFFDDE6EF),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
