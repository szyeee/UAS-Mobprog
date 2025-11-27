// lib/models/order.dart
import 'cart_item.dart';
import 'package:intl/intl.dart';

enum PaymentMethod { cash, card, ewallet }

enum Fulfillment { dineIn, takeaway, delivery }

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final String? note;
  final PaymentMethod paymentMethod;
  final Fulfillment fulfillment;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.items,
    required this.total,
    this.note,
    required this.paymentMethod,
    required this.fulfillment,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// ✅ timestamp langsung dihitung dari createdAt
  int get timestamp => createdAt.millisecondsSinceEpoch;

  /// ✅ formatted date
  String formattedDate({String pattern = 'dd MMM yyyy HH:mm'}) {
    try {
      return DateFormat(pattern).format(createdAt.toLocal());
    } catch (_) {
      return createdAt.toLocal().toString();
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'total': total,
        'note': note,
        'paymentMethod': paymentMethod.toString(),
        'fulfillment': fulfillment.toString(),
        'createdAt': createdAt.millisecondsSinceEpoch,
        'items': items.map((it) => it.toJson()).toList(),
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        items: (json['items'] as List)
            .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        total: (json['total'] as num).toDouble(),
        note: json['note'],
        paymentMethod: PaymentMethod.values.firstWhere(
          (v) => v.toString() == json['paymentMethod'],
          orElse: () => PaymentMethod.cash,
        ),
        fulfillment: Fulfillment.values.firstWhere(
          (v) => v.toString() == json['fulfillment'],
          orElse: () => Fulfillment.delivery,
        ),
        createdAt: json['createdAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'])
            : null,
      );
}
