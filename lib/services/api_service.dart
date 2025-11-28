// lib/services/api_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';

class ApiService {
  static Future<List<Product>> loadProductsFromAsset() async {
    final jsonStr = await rootBundle.loadString('assets/data/products.json');
    final List<dynamic> data = json.decode(jsonStr);
    return data.map((e) => Product.fromJson(e)).toList();
  }
}
