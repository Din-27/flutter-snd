import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/components/loading/loading_button.dart';
import 'package:shop_and_drive/components/loading/loading_overlay.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/core/di/app_services.dart';
import 'package:shop_and_drive/core/theme/app_theme.dart';
import 'package:shop_and_drive/features/payment/presentation/providers/payment_providers.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    this.productName = 'Brake Pad Ceramic',
    this.amount = 850000,
  });

  final String productName;
  final int amount;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const _gateways = [
    _PaymentGateway(
      name: 'Midtrans',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Midtrans_logo.svg/1200px-Midtrans_logo.svg.png',
      description: 'VA, E-Wallet, Kartu Kredit',
      color: Color(0xFF6CC24A),
    ),
    _PaymentGateway(
      name: 'Xendit',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Xendit_logo.svg/1200px-Xendit_logo.svg.png',
      description: 'VA, QRIS, E-Wallet',
      color: Color(0xFF3B82F6),
    ),
    _PaymentGateway(
      name: 'DOKU',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/DOKU_logo.svg/1200px-DOKU_logo.svg.png',
      description: 'VA, Kartu Kredit, PayLater',
      color: Color(0xFFFF6B35),
    ),
    _PaymentGateway(
      name: 'Transfer Bank',
      logo: '',
      description: 'BCA, Mandiri, BNI, BRI',
      color: Color(0xFF1E3A5F),
      icon: Icons.account_balance_rounded,
    ),
  ];

  String _selectedGateway = _gateways.first.name;
  late final PaymentCubit _paymentCubit;

  @override
  void initState() {
    super.initState();
    _paymentCubit = PaymentCubit(AppServices.paymentRepository);
  }

  @override
  void dispose() {
    _paymentCubit.close();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    final formattedAmount = _formatRupiah(widget.amount);

    return BlocProvider.value(
      value: _paymentCubit,
      child: BlocListener<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state.status == PaymentStatus.success && state.payment != null) {
            // Navigate to transaction detail with pending payment status
            context.go('/transaction-detail');
          }
          if (state.status == PaymentStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        child: BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, paymentState) {
            final isSubmitting = paymentState.isLoading;

            return AppPageScaffold(
              title: 'Checkout',
              currentIndex: null,
              body: LoadingOverlay(
                isLoading: isSubmitting,
                message: 'Membuat pembayaran...',
                child: SingleChildScrollView(
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

                      // Payment Gateway Selection
                      const Text(
                        'Pilih Metode Pembayaran',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pilih payment gateway favorit Anda',
                        style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 16),

                      // Gateway Cards
                      ..._gateways.map((gateway) {
                        final isSelected = _selectedGateway == gateway.name;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedGateway = gateway.name),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? gateway.color : const Color(0xFFE8EBF1),
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: gateway.color.withValues(alpha: 0.2),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Gateway Logo/Icon
                                    Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: gateway.color.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: gateway.icon != null
                                          ? Icon(gateway.icon, color: gateway.color, size: 28)
                                          : Icon(Icons.payment_rounded, color: gateway.color, size: 28),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            gateway.name,
                                            style: TextStyle(
                                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            gateway.description,
                                            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Selection indicator
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected ? gateway.color : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected ? gateway.color : const Color(0xFFD0D7E2),
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 24),

                      // Pay Button
                      SizedBox(
                        width: double.infinity,
                        child: LoadingButton(
                          isLoading: isSubmitting,
                          label: 'Bayar Sekarang',
                          onPressed: () async {
                            await _paymentCubit.createPayment(
                              productName: widget.productName,
                              amount: widget.amount,
                              gateway: _selectedGateway,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PaymentGateway {
  const _PaymentGateway({
    required this.name,
    required this.logo,
    required this.description,
    required this.color,
    this.icon,
  });

  final String name;
  final String logo;
  final String description;
  final Color color;
  final IconData? icon;
}