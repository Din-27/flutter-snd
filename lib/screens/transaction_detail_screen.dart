import 'package:flutter/material.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({
    super.key,
    this.orderId = 'INV-20260717-0001',
    this.gateway = 'Midtrans',
    this.amount = 850000,
  });

  final String orderId;
  final String gateway;
  final int amount;

  String _formatRupiah(int value) {
    final asString = value.toString();
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
    final formattedAmount = _formatRupiah(amount);

    return AppPageScaffold(
      title: 'Detail Transaksi',
      currentIndex: 4,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(orderId, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Gateway: $gateway'),
                const SizedBox(height: 4),
                Text('Total: $formattedAmount'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Progress Transaksi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Stepper(
            currentStep: 2,
            controlsBuilder: (context, details) => const SizedBox.shrink(),
            steps: const [
              Step(
                title: Text('Transaksi Dibuat'),
                content: Text('Order berhasil dibuat oleh customer.'),
                isActive: true,
                state: StepState.complete,
              ),
              Step(
                title: Text('Pembayaran Diverifikasi'),
                content: Text('Pembayaran gateway sudah terverifikasi.'),
                isActive: true,
                state: StepState.complete,
              ),
              Step(
                title: Text('Teknisi Menuju Lokasi'),
                content: Text('Teknisi sedang dalam perjalanan.'),
                isActive: true,
                state: StepState.editing,
              ),
              Step(
                title: Text('Pekerjaan Selesai'),
                content: Text('Menunggu status selesai servis.'),
                isActive: false,
                state: StepState.indexed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
