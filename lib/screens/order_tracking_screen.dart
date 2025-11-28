// lib/screens/order_tracking_screen.dart

import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tracking Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Masukkan nomor pesanan untuk melihat status'),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Nomor Pesanan')),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () {}, child: const Text('Lihat Status')),
          const SizedBox(height: 20),
          const Text('Contoh status:'),
          const SizedBox(height: 8),
          const ListTile(leading: Icon(Icons.check_circle), title: Text('Order diterima'), subtitle: Text('10:00')),
          const ListTile(leading: Icon(Icons.kitchen), title: Text('Sedang diproses'), subtitle: Text('10:05')),
          const ListTile(leading: Icon(Icons.local_shipping), title: Text('Dalam pengiriman'), subtitle: Text('10:30')),
        ]),
      ),
    );
  }
}
