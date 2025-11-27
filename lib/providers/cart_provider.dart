import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  double get totalPrice => _items.values.fold(0.0, (s, e) => s + e.total);
  int get totalItems => _items.values.fold(0, (s, e) => s + e.quantity);

  void add(Product product, {int quantity = 1, String? note}) {
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (existing) {
        existing.quantity += quantity;
        if (note != null && note.isNotEmpty) existing.note = note;
        return existing;
      });
    } else {
      _items[product.id] =
          CartItem(product: product, quantity: quantity, note: note);
    }
    notifyListeners();
  }

  void remove(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateNote(String productId, String note) {
    if (_items.containsKey(productId)) {
      _items[productId]!.note = note.trim().isEmpty ? null : note.trim();
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
