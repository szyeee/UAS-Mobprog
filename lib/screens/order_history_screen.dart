// lib/screens/order_history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>().orders;

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Pesanan')),
      body: orders.isEmpty
          ? const Center(child: Text('Belum ada pesanan'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (_, i) {
                final o = orders[i];
                return ListTile(
                  title: Text('Order #${o.id}'),
                  subtitle: Text(o.formattedDate()),
                  trailing: Text('Rp ${o.total.toStringAsFixed(0)}'),
                  onTap: () {
                    // optional: show order detail dialog
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Order #${o.id}'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tanggal: ${o.formattedDate()}'),
                            const SizedBox(height: 8),
                            Text('Total: Rp ${o.total.toStringAsFixed(0)}'),
                            if (o.note != null) ...[
                              const SizedBox(height: 8),
                              Text('Catatan: ${o.note}'),
                            ],
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Tutup'))
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
