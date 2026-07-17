class PaymentResult {
  const PaymentResult({
    required this.orderId,
    required this.gateway,
    required this.status,
    required this.paidAt,
  });

  final String orderId;
  final String gateway;
  final String status;
  final DateTime paidAt;
}
