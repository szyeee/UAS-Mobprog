import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item.dart';
import '../checkout_screen.dart';

class MenuDetailScreen extends StatefulWidget {
  final String productId;
  const MenuDetailScreen({super.key, required this.productId});
  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  int _quantity = 1;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prodProv = context.read<ProductProvider>();
    final cartProv = context.read<CartProvider>();
    final product = prodProv.findById(widget.productId);

    if (product == null)
      return const Scaffold(
          body: Center(child: Text('Produk tidak ditemukan')));

    final subtotal = product.price * _quantity;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                  product.imageUrl.startsWith('assets/')
                      ? product.imageUrl
                      : 'assets/${product.imageUrl}',
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(height: 240, color: Colors.grey.shade200))),
          const SizedBox(height: 12),
          Text(product.name,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Rp ${product.price.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 18, color: Colors.pink)),
          const SizedBox(height: 12),
          Text(product.description),
          const SizedBox(height: 16),
          Row(children: [
            IconButton(
                onPressed: () {
                  if (_quantity > 1) setState(() => _quantity--);
                },
                icon: const Icon(Icons.remove_circle_outline)),
            Text(_quantity.toString()),
            IconButton(
                onPressed: () => setState(() => _quantity++),
                icon: const Icon(Icons.add_circle_outline)),
            const Spacer(),
            Text('Subtotal: Rp ${subtotal.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 12),
          TextField(
              controller: _noteController,
              maxLines: 2,
              decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                  border: OutlineInputBorder())),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      cartProv.add(product,
                          quantity: _quantity,
                          note: _noteController.text.trim().isEmpty
                              ? null
                              : _noteController.text.trim());
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Ditambahkan ke keranjang')));
                    },
                    child: const Text('Tambah ke Keranjang'))),
            const SizedBox(width: 12),
            Expanded(
                child: OutlinedButton(
                    onPressed: () {
                      final single = CartItem(
                          product: product,
                          quantity: _quantity,
                          note: _noteController.text.trim().isEmpty
                              ? null
                              : _noteController.text.trim());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  CheckoutScreen(singleItem: single)));
                    },
                    child: const Text('Beli Sekarang'))),
          ])
        ]),
      ),
    );
  }
}
