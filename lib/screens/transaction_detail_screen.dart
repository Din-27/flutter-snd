import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/core/theme/app_theme.dart';

enum TransactionStatus {
  pendingPayment,
  processing,
  technicianOtw,
  completed,
}

class TransactionDetailScreen extends StatefulWidget {
  const TransactionDetailScreen({
    super.key,
    this.orderId = 'INV-20260717-0001',
    this.gateway = 'Midtrans',
    this.amount = 850000,
    this.status = TransactionStatus.pendingPayment,
  });

  final String orderId;
  final String gateway;
  final int amount;
  final TransactionStatus status;

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  static const _currentLocation = LatLng(-8.6502, 116.3249);
  static const _workshopLocation = LatLng(-8.6571, 116.3022);
  static const _technicianLocation = LatLng(-8.6535, 116.3135);

  late TransactionStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.status;
  }

  String _formatRupiah(int value) {
    final asString = value.toString();
    final buffer = StringBuffer();
    var count = 0;
    for (var i = asString.length - 1; i >= 0; i--) {
      buffer.write(asString[i]);
      count++;
      if (count % 3 == 0 && i != 0) buffer.write('.');
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  bool get _showMap => _currentStatus == TransactionStatus.technicianOtw;
  bool get _showPaymentButton => _currentStatus == TransactionStatus.pendingPayment;

  void _simulatePayment() {
    setState(() {
      _currentStatus = TransactionStatus.processing;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pembayaran berhasil!')),
    );
  }

  void _simulateTechnicianOtw() {
    setState(() {
      _currentStatus = TransactionStatus.technicianOtw;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedAmount = _formatRupiah(widget.amount);

    return AppPageScaffold(
      title: 'Detail Transaksi',
      currentIndex: null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction Header Card
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.orderId,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gateway: ${widget.gateway}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
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
            const SizedBox(height: 20),

            // Status Badge
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _StatusBadge(
                  label: _currentStatus == TransactionStatus.pendingPayment
                      ? 'Menunggu Pembayaran'
                      : 'Dalam Proses',
                  color: _currentStatus == TransactionStatus.pendingPayment
                      ? Colors.orange
                      : AppTheme.primary,
                ),
                if (_currentStatus != TransactionStatus.pendingPayment)
                  _StatusBadge(label: 'Home Service', color: AppTheme.secondary),
                if (_currentStatus == TransactionStatus.technicianOtw)
                  const _StatusBadge(label: 'Teknisi OTW', color: Color(0xFF264653)),
              ],
            ),
            const SizedBox(height: 20),

            // Payment Button (only show if pending payment)
            if (_showPaymentButton) ...[
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
                    Icon(Icons.payment_rounded, size: 48, color: AppTheme.textSecondary),
                    const SizedBox(height: 12),
                    const Text(
                      'Pembayaran Belum Selesai',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selesaikan pembayaran untuk melanjutkan transaksi',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _simulatePayment,
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('Lanjutkan Pembayaran'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Live Tracking Map (only show if technician OTW)
            if (_showMap) ...[
              const Text(
                'Monitoring Perjalanan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 240,
                  child: FlutterMap(
                    options: const MapOptions(
                      initialCenter: _currentLocation,
                      initialZoom: 13.5,
                      interactionOptions: InteractionOptions(flags: InteractiveFlag.all),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'shop_and_drive',
                      ),
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: [
                              _workshopLocation,
                              LatLng(-8.6540, 116.3100),
                              _technicianLocation,
                              _currentLocation,
                            ],
                            color: AppTheme.secondary,
                            strokeWidth: 4,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _currentLocation,
                            width: 44,
                            height: 44,
                            child: const _MapPin(icon: Icons.home_rounded, color: AppTheme.primary),
                          ),
                          Marker(
                            point: _workshopLocation,
                            width: 40,
                            height: 40,
                            child: const _MapPin(icon: Icons.car_repair_rounded, color: AppTheme.secondary),
                          ),
                          Marker(
                            point: _technicianLocation,
                            width: 46,
                            height: 46,
                            child: _MapPin(icon: Icons.delivery_dining_rounded, color: const Color(0xFF264653)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Map data: OpenStreetMap',
                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 20),
            ],

            // Progress Timeline
            const Text(
              'Progress Transaksi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8EBF1)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _TimelineStep(
                    isDone: _currentStatus != TransactionStatus.pendingPayment,
                    title: 'Transaksi Dibuat',
                    subtitle: 'Order berhasil dibuat oleh customer',
                    time: '09:00',
                  ),
                  _TimelineStep(
                    isDone: _currentStatus != TransactionStatus.pendingPayment,
                    title: 'Pembayaran Diverifikasi',
                    subtitle: 'Pembayaran gateway sudah terverifikasi',
                    time: _currentStatus == TransactionStatus.pendingPayment ? 'Menunggu' : '09:12',
                  ),
                  _TimelineStep(
                    isDone: _currentStatus == TransactionStatus.technicianOtw,
                    title: 'Teknisi Berangkat',
                    subtitle: 'Teknisi berangkat dari Bengkel AutoCare',
                    time: _currentStatus == TransactionStatus.technicianOtw ? '09:18' : 'Menunggu',
                  ),
                  _TimelineStep(
                    isDone: false,
                    title: 'Dalam Perjalanan',
                    subtitle: 'ETA 12 menit - Live tracking aktif',
                    time: _currentStatus == TransactionStatus.technicianOtw ? '09:20' : 'Menunggu',
                    isActive: _currentStatus == TransactionStatus.technicianOtw,
                  ),
                  _TimelineStep(
                    isDone: false,
                    title: 'Pekerjaan Selesai',
                    subtitle: 'Menunggu konfirmasi selesai servis',
                    time: 'Menunggu',
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            if (!_showPaymentButton) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.home_rounded),
                      label: const Text('Home'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _currentStatus == TransactionStatus.processing
                          ? _simulateTechnicianOtw
                          : () {},
                      icon: Icon(
                        _currentStatus == TransactionStatus.processing
                            ? Icons.delivery_dining_rounded
                            : Icons.phone_rounded,
                      ),
                      label: Text(
                        _currentStatus == TransactionStatus.processing
                            ? 'Simulasi OTW'
                            : 'Hubungi Teknisi',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.icon, required this.color});
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Color.fromARGB(61, 0, 0, 0), blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.isDone,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isActive = false,
    this.isLast = false,
  });
  final bool isDone;
  final String title;
  final String subtitle;
  final String time;
  final bool isActive;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final dotColor = isDone
        ? AppTheme.primary
        : isActive
            ? AppTheme.secondary
            : const Color(0xFFB7C1D1);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: isActive ? 16 : 12,
              height: isActive ? 16 : 12,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                border: isActive ? Border.all(color: AppTheme.secondary.withValues(alpha: 0.3), width: 3) : null,
              ),
            ),
            if (!isLast) Container(width: 2, height: 36, color: const Color(0xFFD0D7E2)),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    color: isActive ? AppTheme.secondary : AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ),
        Text(time, style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
      ],
    );
  }
}