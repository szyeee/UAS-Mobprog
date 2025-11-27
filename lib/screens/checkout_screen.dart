import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import 'payment_method_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final CartItem? singleItem;
  const CheckoutScreen({super.key, this.singleItem});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? selectedPayment;

  @override
  Widget build(BuildContext context) {
    final cartProv = context.watch<CartProvider>();

    final items = widget.singleItem != null
        ? [widget.singleItem!]
        : cartProv.items.values.toList();

    final total = items.fold<double>(0, (s, e) => s + e.total);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Pesanan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (ctx, i) {
                  final it = items[i];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        it.product.imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(it.product.name),
                    subtitle: Text(
                      'Qty: ${it.quantity}${it.note != null ? ' • ${it.note!}' : ''}',
                    ),
                    trailing: Text('Rp ${it.total.toStringAsFixed(0)}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Metode Pembayaran'),
              subtitle: Text(
                selectedPayment ?? 'Belum dipilih',
                style: const TextStyle(color: Colors.black54),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentMethodScreen(),
                  ),
                );
                if (result != null) {
                  setState(() => selectedPayment = result);
                }
              },
            ),
            const SizedBox(height: 12),
            Text(
              'Total: Rp ${total.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedPayment == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pilih metode pembayaran dulu 😊'),
                    ),
                  );
                  return;
                }

                // ✅ konversi string -> enum
                final payment = PaymentMethod.values.firstWhere(
                  (e) => e.name == selectedPayment!.toLowerCase(),
                  orElse: () => PaymentMethod.cash,
                );

                // ✅ SIMPAN ORDER
                context.read<OrderProvider>().addOrder(
                      Order(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        items: items,
                        total: total,
                        paymentMethod: payment,
                        fulfillment: Fulfillment.delivery,
                      ),
                    );

                if (widget.singleItem == null) {
                  cartProv.clear();
                }

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Sukses'),
                    content: Text(
                      'Pesanan berhasil diproses via $selectedPayment ✅',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.popUntil(
                          context,
                          (r) => r.isFirst,
                        ),
                        child: const Text('OK'),
                      )
                    ],
                  ),
                );
              },
              child: const Text('Bayar Sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}
