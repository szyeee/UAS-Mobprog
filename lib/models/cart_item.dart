// lib/models/cart_item.dart
import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  String? note;

  CartItem({required this.product, this.quantity = 1, this.note});

  double get total => product.price * quantity;

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
        'note': note,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        product: Product.fromJson(Map<String, dynamic>.from(json['product'])),
        quantity: json['quantity'] ?? 1,
        note: json['note'],
      );
}
