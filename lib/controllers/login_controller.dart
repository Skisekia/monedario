import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginController {
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;

  final VoidCallback onSuccess;
  final Function(String) onError;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginController({
    required this.emailCtrl,
    required this.passCtrl,
    required this.onSuccess,
    required this.onError,
  });

  Future<void> loginUser(BuildContext context) async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      onError("Completa ambos campos.");
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      String msg = "Error al iniciar sesión.";
      if (e.code == 'user-not-found') msg = "Usuario no registrado.";
      if (e.code == 'wrong-password') msg = "Contraseña incorrecta.";
      if (e.code == 'invalid-email') msg = "Correo inválido.";
      onError(msg);
    } catch (e) {
      onError("Error inesperado: ${e.toString()}");
    }
  }

  Future<void> signInWithGoogle() async {
    // Aquí también puedes implementar Google Sign-In para login
  }
}
