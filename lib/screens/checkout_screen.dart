import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/components/loading/loading_button.dart';
import 'package:shop_and_drive/components/loading/loading_overlay.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/features/payment/domain/models/payment_result.dart';
import 'package:shop_and_drive/features/payment/presentation/providers/payment_providers.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({
    super.key,
    this.productName = 'Brake Pad Ceramic',
    this.amount = 850000,
  });

  final String productName;
  final int amount;

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  static const _gateways = [
    'Midtrans',
    'Xendit',
    'DOKU',
    'Transfer Bank',
  ];

  String _selectedGateway = _gateways.first;

  String _formatRupiah(int amount) {
    final asString = amount.toString();
    final buffer = StringBuffer();
    var count = 0;

    for (var i = asString.length - 1; i >= 0; i--) {
      buffer.write(asString[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }

    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<PaymentResult?>>(paymentControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (payment) {
          if (payment != null) {
            final gateway = Uri.encodeComponent(payment.gateway);
            context.go(
              '/transaction-detail?orderId=${payment.orderId}&gateway=$gateway&amount=${widget.amount}',
            );
          }
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
      );
    });

    final paymentState = ref.watch(paymentControllerProvider);
    final isSubmitting = paymentState.isLoading;
    final formattedAmount = _formatRupiah(widget.amount);

    return AppPageScaffold(
      title: 'Checkout',
      currentIndex: 1,
      body: LoadingOverlay(
        isLoading: isSubmitting,
        message: 'Membuat pembayaran...',
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Card(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ringkasan Pesanan', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(widget.productName),
                  const SizedBox(height: 4),
                  Text(
                    formattedAmount,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Pilih Payment Gateway',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ..._gateways.map((gateway) {
              return RadioListTile<String>(
                value: gateway,
                groupValue: _selectedGateway,
                activeColor: const Color(0xFF5C4E4B),
                title: Text(gateway),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedGateway = value;
                  });
                },
              );
            }),
            const SizedBox(height: 14),
            const Text(
              'Invoice (Image Preview)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                'https://dummyimage.com/1200x700/fff0ee/5c4e4b.png&text=INVOICE+SHOP+%26+DRIVE',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: LoadingButton(
                isLoading: isSubmitting,
                label: 'Bayar Sekarang',
                onPressed: () async {
                  await ref.read(paymentControllerProvider.notifier).createPayment(
                    productName: widget.productName,
                    amount: widget.amount,
                    gateway: _selectedGateway,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
