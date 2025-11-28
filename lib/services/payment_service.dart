// lib/services/payment_service.dart  

import 'dart:math';


class PaymentService {
/// Simulasi pembayaran: tunggu beberapa saat lalu kembalikan fake transaction id
static Future<String> simulatePayment() async {
await Future.delayed(const Duration(seconds: 2));
final id = 'TX-${Random().nextInt(999999).toString().padLeft(6, '0')}';
return id;
}
}