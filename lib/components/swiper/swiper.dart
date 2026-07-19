import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:shop_and_drive/models/swiper_item.dart';
export 'package:shop_and_drive/models/swiper_item.dart';

enum SwiperContentType { banner, product }

class AppSwiper extends StatelessWidget {
  const AppSwiper.banner({
    super.key,
    required this.banners,
    this.viewportFraction = 0.9,
    this.height = 170,
    this.autoPlayDuration = const Duration(seconds: 3),
    this.onBannerTap,
  })  : products = const [],
        onProductTap = null,
        contentType = SwiperContentType.banner;

  const AppSwiper.product({
    super.key,
    required this.products,
    this.viewportFraction = 0.84,
    this.height = 220,
    this.autoPlayDuration = const Duration(seconds: 3),
    this.onProductTap,
  })  : banners = const [],
        onBannerTap = null,
        contentType = SwiperContentType.product;

  final List<BannerSwiperItem> banners;
  final List<ProductSwiperItem> products;
  final SwiperContentType contentType;
  final double viewportFraction;
  final double height;
  final Duration autoPlayDuration;
  final void Function(BannerSwiperItem)? onBannerTap;
  final void Function(ProductSwiperItem)? onProductTap;

  @override
  Widget build(BuildContext context) {
    final itemCount = contentType == SwiperContentType.banner
        ? banners.length
        : products.length;

    if (itemCount == 0) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: height,
      child: Swiper(
        itemCount: itemCount,
        viewportFraction: viewportFraction,
        scale: 0.94,
        autoplay: itemCount > 1,
        autoplayDelay: autoPlayDuration.inMilliseconds,
        duration: 350,
        physics: const ClampingScrollPhysics(),
        pagination: const SwiperPagination(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 8),
          builder: DotSwiperPaginationBuilder(
            color: Color(0xFFD6D6D6),
            activeColor: Color(0xFFFFF0EE),
            size: 8,
            activeSize: 8,
            space: 4,
          ),
        ),
        itemBuilder: (context, index) {
          if (contentType == SwiperContentType.banner) {
            return _BannerSwiperCard(
              item: banners[index],
              onTap: onBannerTap != null ? () => onBannerTap!(banners[index]) : null,
            );
          }

          return _ProductSwiperCard(
            item: products[index],
            onTap: onProductTap != null ? () => onProductTap!(products[index]) : null,
          );
        },
      ),
    );
  }
}

class _BannerSwiperCard extends StatelessWidget {
  const _BannerSwiperCard({required this.item, this.onTap});

  final BannerSwiperItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(22, 0, 0, 0),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _NetworkImageWithFallback(imageUrl: item.imageUrl),
              if (item.title != null || item.subtitle != null)
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(170, 0, 0, 0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.title != null)
                          Text(
                            item.title!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        if (item.subtitle != null)
                          Text(
                            item.subtitle!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductSwiperCard extends StatelessWidget {
  const _ProductSwiperCard({required this.item, this.onTap});

  final ProductSwiperItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(22, 0, 0, 0),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _NetworkImageWithFallback(imageUrl: item.imageUrl),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0EE),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          item.category,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF383230),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: Color(0xFFFFC83D),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5F5654),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        item.price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF383230),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NetworkImageWithFallback extends StatelessWidget {
  const _NetworkImageWithFallback({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFF0EE)),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFFF0F0F0),
          child: const Center(
            child: Icon(Icons.broken_image_outlined, size: 30),
          ),
        );
      },
    );
  }
}
