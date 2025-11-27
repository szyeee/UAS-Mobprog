import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  bool isFavorite(String id) {
    return _favorites.any((item) => item['id'] == id);
  }

  void toggleFavorite(Map<String, dynamic> product) {
    if (isFavorite(product['id'])) {
      _favorites.removeWhere((item) => item['id'] == product['id']);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }
}
