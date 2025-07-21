import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController {
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final VoidCallback onLoginSuccess;
  final void Function(String) onError;

  LoginController({
    required this.emailCtrl,
    required this.passCtrl,
    required this.onLoginSuccess,
    required this.onError,
  });

  Future<void> signInWithEmail() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );
      onLoginSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message ?? 'Error al iniciar sesión');
    } catch (_) {
      onError('Ocurrió un error inesperado');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw Exception('Cancelado por usuario');
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      onLoginSuccess();
    } catch (_) {
      onError('Ocurrió un error al iniciar sesión con Google');
    }
  }
}
