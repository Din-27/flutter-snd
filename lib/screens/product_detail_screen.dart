import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/core/theme/app_theme.dart';
import 'package:shop_and_drive/utils/toast.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    this.productId,
    this.name = 'Produk',
    this.category = 'Sparepart',
    this.price = 850000,
    this.imageUrl = '',
    this.rating = 4.5,
  });

  final String? productId;
  final String name;
  final String category;
  final int price;
  final String imageUrl;
  final double rating;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  static const _deliveryFee = 15000;

  int _quantity = 1;
  bool _isDelivery = false;

  String _formatRupiah(int amount) {
    final asString = amount.toString();
    final buffer = StringBuffer();
    var count = 0;
    for (var i = asString.length - 1; i >= 0; i--) {
      buffer.write(asString[i]);
      count++;
      if (count % 3 == 0 && i != 0) buffer.write('.');
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  int get _subtotal => widget.price * _quantity;
  int get _deliveryCost => _isDelivery ? _deliveryFee : 0;
  int get _total => _subtotal + _deliveryCost;

  void _proceedToCheckout() {
    final encodedName = Uri.encodeComponent(widget.name);
    context.go(
      '/checkout?product=$encodedName&amount=$_total&quantity=$_quantity&delivery=${_isDelivery ? '1' : '0'}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Detail Produk',
      currentIndex: null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              child: AspectRatio(
                aspectRatio: 16 / 12,
                child: Image.network(
                  widget.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: AppTheme.accent,
                    child: const Icon(Icons.image_rounded, color: AppTheme.primary, size: 64),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Rating
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.star_rounded, size: 18, color: AppTheme.secondary),
                      const SizedBox(width: 4),
                      Text(
                        widget.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Product Name
                  Text(
                    widget.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Text(
                    _formatRupiah(widget.price),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'per unit',
                    style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE8EBF1)),
                    ),
                    child: const Text(
                      'Produk original berkualitas tinggi dengan garansi resmi. '
                      'Cocok untuk berbagai jenis kendaraan. Material premium dengan '
                      'daya tahan maksimal. Diproduksi dengan standar industri terbaru '
                      'untuk performa optimal kendaraan Anda.\n\n'
                      'Fitur Unggulan:\n'
                      '• Material berkualitas tinggi\n'
                      '• Tahan lama dan awet\n'
                      '• Mudah dipasang\n'
                      '• Garansi resmi 6 bulan\n'
                      '• Kompatibel dengan berbagai tipe kendaraan',
                      style: TextStyle(fontSize: 13, height: 1.6, color: AppTheme.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Specifications
                  const Text(
                    'Spesifikasi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE8EBF1)),
                    ),
                    child: Column(
                      children: const [
                        _SpecRow(label: 'Kategori', value: 'Sparepart'),
                        _SpecRow(label: 'Berat', value: '1.5 kg'),
                        _SpecRow(label: 'Dimensi', value: '30 x 20 x 10 cm'),
                        _SpecRow(label: 'Material', value: 'Ceramic Composite'),
                        _SpecRow(label: 'Garansi', value: '6 Bulan'),
                        _SpecRow(label: 'Stok', value: 'Tersedia'),
                        _SpecRow(label: 'Pengiriman', value: '1-3 Hari Kerja', isLast: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Seller Info
                  const Text(
                    'Informasi Penjual',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE8EBF1)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.store_rounded, color: AppTheme.primary, size: 28),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('AutoCare Official Store', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.verified_rounded, size: 16, color: AppTheme.secondary),
                                  SizedBox(width: 4),
                                  Text('Verified Seller', style: TextStyle(fontSize: 12, color: AppTheme.secondary, fontWeight: FontWeight.w600)),
                                  SizedBox(width: 12),
                                  Icon(Icons.star_rounded, size: 14, color: AppTheme.secondary),
                                  SizedBox(width: 2),
                                  Text('4.8 (2.3rb)', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        FilledButton(
                          onPressed: () => showToast(context, 'Membuka halaman AutoCare Official Store'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.accent,
                            foregroundColor: AppTheme.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Kunjungi', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Reviews Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ulasan Pembeli',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => showToast(context, 'Menampilkan semua ulasan (128)'),
                        child: Text('Lihat Semua', style: TextStyle(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE8EBF1)),
                    ),
                    child: Column(
                      children: [
                        // Review Summary
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  widget.rating.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: List.generate(5, (i) => Icon(
                                    i < widget.rating.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
                                    size: 14, color: AppTheme.secondary,
                                  )),
                                ),
                                const SizedBox(height: 4),
                                Text('128 Ulasan', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                              ],
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                children: [
                                  _RatingBar(stars: 5, count: 98, total: 128),
                                  _RatingBar(stars: 4, count: 22, total: 128),
                                  _RatingBar(stars: 3, count: 5, total: 128),
                                  _RatingBar(stars: 2, count: 2, total: 128),
                                  _RatingBar(stars: 1, count: 1, total: 128),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        // Individual Reviews
                        const _ReviewItem(
                          name: 'Budi Santoso',
                          date: '2 hari lalu',
                          rating: 5,
                          comment: 'Produk original, packing rapi, pengiriman cepat. Sangat recommended!',
                          avatar: 'B',
                        ),
                        const _ReviewItem(
                          name: 'Siti Rahayu',
                          date: '5 hari lalu',
                          rating: 4,
                          comment: 'Kualitas bagus, sesuai deskripsi. Hanya pengiriman agak lama.',
                          avatar: 'S',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quantity Selector
                  const Text(
                    'Jumlah',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE8EBF1)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _QuantityButton(
                          icon: Icons.remove_rounded,
                          onTap: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Text(
                            '$_quantity',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _QuantityButton(
                          icon: Icons.add_rounded,
                          onTap: () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Delivery Method
                  const Text(
                    'Metode Pengambilan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Pickup Option
                  GestureDetector(
                    onTap: () => setState(() => _isDelivery = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: !_isDelivery ? AppTheme.primary : const Color(0xFFE8EBF1),
                          width: !_isDelivery ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: !_isDelivery ? AppTheme.primary.withValues(alpha: 0.1) : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.store_rounded,
                              color: !_isDelivery ? AppTheme.primary : AppTheme.textSecondary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Ambil di Bengkel', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                SizedBox(height: 2),
                                Text('Gratis ongkos kirim', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                              ],
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: !_isDelivery ? AppTheme.primary : const Color(0xFFD0D7E2),
                                width: 2,
                              ),
                            ),
                            child: !_isDelivery
                                ? Center(
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Delivery Option
                  GestureDetector(
                    onTap: () => setState(() => _isDelivery = true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _isDelivery ? AppTheme.primary : const Color(0xFFE8EBF1),
                          width: _isDelivery ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: _isDelivery ? AppTheme.primary.withValues(alpha: 0.1) : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.delivery_dining_rounded,
                              color: _isDelivery ? AppTheme.primary : AppTheme.textSecondary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Diantar ke Lokasi', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                const SizedBox(height: 2),
                                Text(
                                  'Biaya pengiriman: ${_formatRupiah(_deliveryFee)}',
                                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _isDelivery ? AppTheme.primary : const Color(0xFFD0D7E2),
                                width: 2,
                              ),
                            ),
                            child: _isDelivery
                                ? Center(
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Order Summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE8EBF1)),
                    ),
                    child: Column(
                      children: [
                        _SummaryRow(label: 'Harga (${_quantity}x)', value: _formatRupiah(_subtotal)),
                        if (_isDelivery) ...[
                          const SizedBox(height: 8),
                          _SummaryRow(label: 'Biaya Pengiriman', value: _formatRupiah(_deliveryCost)),
                        ],
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          label: 'Total',
                          value: _formatRupiah(_total),
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Checkout Button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _proceedToCheckout,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Lanjutkan ke Checkout'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDisabled ? const Color(0xFFF5F5F5) : AppTheme.accent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 22,
          color: isDisabled ? AppTheme.textSecondary : AppTheme.primary,
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.isBold = false});
  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? AppTheme.textPrimary : AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? AppTheme.primary : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({required this.label, required this.value, this.isLast = false});
  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  const _RatingBar({required this.stars, required this.count, required this.total});
  final int stars;
  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ratio = count / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text('$stars★', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 6,
                backgroundColor: const Color(0xFFF0F0F0),
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.secondary),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(width: 24, child: Text('$count', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary))),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  const _ReviewItem({
    required this.name,
    required this.date,
    required this.rating,
    required this.comment,
    required this.avatar,
    this.isLast = false,
  });
  final String name;
  final String date;
  final int rating;
  final String comment;
  final String avatar;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.accent,
            child: Text(avatar, style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary, fontSize: 14)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(width: 8),
                    ...List.generate(rating, (_) => const Icon(Icons.star_rounded, size: 12, color: AppTheme.secondary)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(date, style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                const SizedBox(height: 4),
                Text(comment, style: const TextStyle(fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
