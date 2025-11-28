// lib/screens/payment_method_screen.dart

import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  final methods = const [
    'Dana',
    'OVO',
    'GoPay',
    'Transfer Bank',
    'Cash on Delivery'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Metode Pembayaran')),
      body: ListView.separated(
        itemCount: methods.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          return ListTile(
            title: Text(methods[i]),
            onTap: () => Navigator.pop(context, methods[i]),
          );
        },
      ),
    );
  }
}
