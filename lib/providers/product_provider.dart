// lib/providers/product_provider.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];
  bool _loading = false;

  List<Product> get items => List.unmodifiable(_items);
  bool get loading => _loading;

  String normalizeCategory(String value) => value.trim().toLowerCase();

  Future<void> loadProducts() async {
    _loading = true;
    notifyListeners();
    try {
      final data = await rootBundle.loadString('assets/data/products.json');
      final decoded = json.decode(data) as List;
      _items = decoded
          .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      debugPrint('Error loading products: $e');
      _items = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Product? findById(String id) {
    try {
      return _items.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Product> filterByCategory(String category) {
    if (category.toLowerCase() == 'all') return items;
    return _items
        .where(
            (p) => normalizeCategory(p.category) == normalizeCategory(category))
        .toList();
  }

  // ✅ GET REVIEWS
  List<Map<String, dynamic>> getReviews(String productId) {
    final p = findById(productId);
    return p?.reviews ?? [];
  }

  // ✅ ADD REVIEW
  Future<void> addReview(
      String productId, double rating, String? comment) async {
    final p = findById(productId);
    if (p == null) return;

    p.reviews.add({
      'rating': rating,
      'comment': comment,
      'ts': DateTime.now().millisecondsSinceEpoch,
    });

    notifyListeners();
  }

  // ✅ AVERAGE RATING
  double getAverageRating(String productId) {
    final p = findById(productId);
    if (p == null || p.reviews.isEmpty) return 0;

    final total = p.reviews.fold<double>(
      0,
      (sum, r) => sum + (r['rating'] as num).toDouble(),
    );

    return total / p.reviews.length;
  }
}
