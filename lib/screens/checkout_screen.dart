import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/core/di/app_services.dart';
import 'package:shop_and_drive/core/theme/app_theme.dart';
import 'package:shop_and_drive/models/api_models.dart';
import 'package:shop_and_drive/utils/toast.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    this.productId,
    this.productName = 'Brake Pad Ceramic',
    this.amount = 850000,
    this.quantity = 1,
  });

  final String? productId;
  final String productName;
  final int amount;
  final int quantity;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isSubmitting = false;

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

  Future<void> _createOrder() async {
    setState(() => _isSubmitting = true);

    final request = CreateOrderRequest(
      items: [
        CreateOrderItemRequest(
          productId: widget.productId ?? 'unknown',
          quantity: widget.quantity,
        ),
      ],
    );

    final result = await AppServices.orderRepository.createOrder(request);

    if (mounted) {
      setState(() => _isSubmitting = false);
      result.when(
        success: (order) {
          showToast(context, 'Pesanan berhasil dibuat! #${order.id}');
          context.go('/transaction-detail');
        },
        failure: (error) => showToast(context, error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedAmount = _formatRupiah(widget.amount);

    return AppPageScaffold(
      title: 'Checkout',
      currentIndex: null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, Color(0xFFA91F33)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.productName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Qty: ${widget.quantity}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      formattedAmount,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Order Details
            const Text('Detail Pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8EBF1)),
              ),
              child: Column(
                children: [
                  _DetailRow(label: 'Produk', value: widget.productName),
                  const SizedBox(height: 8),
                  _DetailRow(label: 'Jumlah', value: '${widget.quantity} unit'),
                  const SizedBox(height: 8),
                  _DetailRow(label: 'Harga Satuan', value: _formatRupiah(widget.amount ~/ widget.quantity)),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  _DetailRow(label: 'Total', value: formattedAmount, isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : _createOrder,
                icon: _isSubmitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.check_rounded),
                label: Text(_isSubmitting ? 'Membuat Pesanan...' : 'Konfirmasi Pesanan'),
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
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.isBold = false});
  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? AppTheme.primary : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}