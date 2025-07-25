import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> login(String email, String password) async {
    _loading = true;
    notifyListeners();

    // Aquí usarías FirebaseAuth realmente:
    await Future.delayed(const Duration(seconds: 2));

    _loading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    final user = _auth.currentUser;
    if (user != null) {
      for (final info in user.providerData) {
        if (info.providerId == 'google.com') {
          await GoogleSignIn().signOut();
        } else if (info.providerId == 'facebook.com') {
          await FacebookAuth.instance.logOut();
        }
      }
    }
    await _auth.signOut();
    notifyListeners(); // notificar cambios si alguien observa el estado
  }
}
