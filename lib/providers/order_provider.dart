// lib/providers/order_provider.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  OrderProvider() {
    _loadOrders();
  }

  // ✅ load saat app mulai
  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('orders');

    if (data != null) {
      final List decoded = jsonDecode(data);
      _orders = decoded.map((e) => Order.fromJson(e)).toList();
      notifyListeners();
    }
  }

  // ✅ simpan setiap ada pesanan baru
  Future<void> addOrder(Order order) async {
    _orders.add(order);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'orders',
      jsonEncode(_orders.map((e) => e.toJson()).toList()),
    );
  }

  // ✅ opsi: bersihkan saat logout
  Future<void> clearOrders() async {
    _orders.clear();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('orders');
  }
}
