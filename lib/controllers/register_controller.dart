import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterController {
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final TextEditingController pass2Ctrl;
  final TextEditingController nameCtrl;

  final VoidCallback onSuccess;
  final Function(String) onError;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  RegisterController({
    required this.emailCtrl,
    required this.passCtrl,
    required this.pass2Ctrl,
    required this.nameCtrl,
    required this.onSuccess,
    required this.onError,
  });

  Future<void> registerUser(BuildContext context) async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();
    final pass2 = pass2Ctrl.text.trim();
    final name = nameCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty || name.isEmpty || pass2.isEmpty) {
      onError("Completa todos los campos.");
      return;
    }

    if (pass != pass2) {
      onError("Las contraseñas no coinciden.");
      return;
    }

    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      await cred.user!.updateDisplayName(name);
      await cred.user!.reload();

      onSuccess();
    } on FirebaseAuthException catch (e) {
      String msg = "Error al registrar.";
      if (e.code == 'email-already-in-use') msg = "El correo ya está en uso.";
      if (e.code == 'invalid-email') msg = "Correo inválido.";
      if (e.code == 'weak-password') msg = "Contraseña muy débil.";
      onError(msg);
    } catch (e) {
      onError("Error inesperado: ${e.toString()}");
    }
  }

  Future<void> signInWithGoogle() async {
    // Puedes implementar aquí tu flujo de Google Sign-In
    // y luego llamar a onSuccess() si fue exitoso
  }
}
