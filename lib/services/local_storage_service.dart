// lib/services/local_storage_service.dart (tambah openBox reviews_box)
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static const cartBox = 'cart_box';
  static const reviewsBox = 'reviews_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(cartBox);
    await Hive.openBox(reviewsBox); 
  }

  static Box getCartBox() => Hive.box(cartBox);
  static Box getReviewsBox() => Hive.box(reviewsBox);
}
