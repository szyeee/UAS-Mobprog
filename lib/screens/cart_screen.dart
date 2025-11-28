// lib/screens/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final prov = context.watch<CartProvider>();
    final items = prov.items.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang')),
      body: prov.items.isEmpty
          ? const Center(child: Text('Keranjang kosong'))
          : Column(children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  itemBuilder: (ctx, i) {
                    final it = items[i];
                    final noteController = TextEditingController(text: it.note);
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                                it.product.imageUrl.startsWith('assets/')
                                    ? it.product.imageUrl
                                    : 'assets/${it.product.imageUrl}',
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                    width: 56,
                                    height: 56,
                                    color: Colors.grey.shade200))),
                        title: Text(it.product.name),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rp ${it.total.toStringAsFixed(0)}'),
                              const SizedBox(height: 6),
                              TextField(
                                  key: ValueKey(it.product.id),
                                  controller: noteController,
                                  decoration: const InputDecoration(
                                      hintText: 'Catatan (opsional)'),
                                  onSubmitted: (v) =>
                                      prov.updateNote(it.product.id, v)),
                            ]),
                        trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => prov.remove(it.product.id)),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Total: Rp ${prov.totalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const CheckoutScreen())),
                          child: const Text('Checkout'))
                    ]),
              )
            ]),
    );
  }
}
