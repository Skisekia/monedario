import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _loading = false;
  bool get loading => _loading;

// Método para iniciar sesión con correo electrónico y contraseña
  Future<void> login(String email, String password) async {
    _loading = true;
    notifyListeners();


    await Future.delayed(const Duration(seconds: 2));

    _loading = false;
    notifyListeners();
  }

// Método para iniciar sesión con Google
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
    notifyListeners();
  }

  UserModel? getCurrentUserModel() {
    final user = _auth.currentUser;
    if (user == null) return null;

// Determinar el proveedor
    final providerId = user.providerData.isNotEmpty ? user.providerData.first.providerId : '';
    String provider = 'email';
    if (providerId.contains("google")) provider = 'google';
    if (providerId.contains("facebook")) provider = 'facebook';
    if (providerId.contains("apple")) provider = 'apple';

// Crear el modelo de usuario
    return UserModel(
      name: user.displayName ?? user.email ?? 'Sin nombre',
      gender: 'Otro', 
      provider: provider,
    );
  }
}
