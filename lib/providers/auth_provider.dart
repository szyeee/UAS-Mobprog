import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String _name = "Adelia Sassy Mulya";
  String _email = "adelia@example.com";

  bool _isLoggedIn = true;

  String get name => _name;
  String get email => _email;
  bool get isLoggedIn => _isLoggedIn;

  void updateProfile({
    required String newName,
    required String newEmail,
  }) {
    _name = newName;
    _email = newEmail;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void login({
    required String name,
    required String email,
  }) {
    _name = name;
    _email = email;
    _isLoggedIn = true;
    notifyListeners();
  }
}
