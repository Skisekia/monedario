import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  Future<void> login(String email, String password) async {
    _loading = true;
    notifyListeners();

    // Simula delay o llama a FirebaseAuth
    await Future.delayed(const Duration(seconds: 2));

    _loading = false;
    notifyListeners();
  }
}
