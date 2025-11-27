import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/rating_stars.dart';
import 'checkout_screen.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final _noteController = TextEditingController();
  final _reviewController = TextEditingController();

  int _quantity = 1;
  double _userRating = 5.0;

  @override
  void dispose() {
    _noteController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ProductProvider>();
    final cart = context.read<CartProvider>();

    final product = prov.findById(widget.productId);

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text("Produk tidak ditemukan")),
      );
    }

    final avg = prov.getAverageRating(product.id);
    final reviews = prov.getReviews(product.id);

    final subtotal = product.price * _quantity;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              product.imageUrl,
              height: 260,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            product.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Row(children: [
            RatingStars(
              rating: avg,
              onRatingChanged: null,
              size: 20,
              allowHalf: true,
            ),
            const SizedBox(width: 8),
            Text(
              avg > 0 ? avg.toStringAsFixed(1) : 'Belum ada rating',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(width: 6),
            Text(
              '(${reviews.length})',
              style: const TextStyle(color: Colors.black45),
            ),
          ]),

          const SizedBox(height: 12),

          Text(
            'Rp ${product.price.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.pink,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            product.description,
            style: const TextStyle(height: 1.4),
          ),

          const SizedBox(height: 18),

          // quantity and subtotal
          Row(children: [
            IconButton(
              onPressed: () {
                if (_quantity > 1) setState(() => _quantity--);
              },
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(_quantity.toString(), style: const TextStyle(fontSize: 18)),
            IconButton(
              onPressed: () => setState(() => _quantity++),
              icon: const Icon(Icons.add_circle_outline),
            ),
            const Spacer(),
            Text(
              'Subtotal: Rp ${subtotal.toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ]),

          const SizedBox(height: 16),

          TextField(
            controller: _noteController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Catatan untuk item (opsional)',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          Row(children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  cart.add(
                    product,
                    quantity: _quantity,
                    note: _noteController.text.trim().isEmpty
                        ? null
                        : _noteController.text.trim(),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ditambahkan ke keranjang')),
                  );
                },
                child: const Text('Tambah ke Keranjang'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  final single = CartItem(
                    product: product,
                    quantity: _quantity,
                    note: _noteController.text.trim().isEmpty
                        ? null
                        : _noteController.text.trim(),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CheckoutScreen(singleItem: single),
                    ),
                  );
                },
                child: const Text('Beli Sekarang'),
              ),
            ),
          ]),

          const SizedBox(height: 28),

          // reviews section
          const Text(
            'Ulasan & Rating',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          // add review box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tambahkan Ulasan',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(children: [
                  RatingStars(
                    rating: _userRating,
                    onRatingChanged: (r) => setState(() => _userRating = r),
                  ),
                  const Spacer(),
                  Text(_userRating.toStringAsFixed(1)),
                ]),
                const SizedBox(height: 10),
                TextField(
                  controller: _reviewController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Tulis ulasan...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      final comment = _reviewController.text.trim();

                      await prov.addReview(
                        product.id,
                        _userRating,
                        comment.isEmpty ? null : comment,
                      );

                      _reviewController.clear();
                      setState(() => _userRating = 5.0);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Terima kasih atas ulasanmu'),
                        ),
                      );
                    },
                    child: const Text('Kirim Ulasan'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // reviews list
          if (reviews.isEmpty)
            const Text('Belum ada ulasan untuk produk ini.')
          else
            Column(
              children: reviews.reversed.map((r) {
                final rating = (r['rating'] as num).toDouble();
                final comment = (r['comment'] ?? '') as String;
                final ts = DateTime.fromMillisecondsSinceEpoch(r['ts']);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: RatingStars(
                      rating: rating,
                      onRatingChanged: null,
                      size: 16,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (comment.isNotEmpty) Text(comment),
                        const SizedBox(height: 4),
                        Text(
                          ts.toLocal().toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )
        ]),
      ),
    );
  }
}
