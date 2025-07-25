import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterController {
  // ======== Controladores de campos de entrada ========
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final TextEditingController pass2Ctrl;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final String gender;

  // ======== Callbacks para notificar éxito o error ========
  final VoidCallback onSuccess;
  final Function(String) onError;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  RegisterController({
    required this.emailCtrl,
    required this.passCtrl,
    required this.pass2Ctrl,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.gender,
    required this.onSuccess,
    required this.onError,
  });

  // ======== Lógica de registro principal ========
  Future<void> registerUser(BuildContext context) async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();
    final pass2 = pass2Ctrl.text.trim();
    final name = nameCtrl.text.trim();
    final phone = phoneCtrl.text.trim();

    // Validaciones
    if (email.isEmpty || pass.isEmpty || name.isEmpty || pass2.isEmpty || phone.isEmpty) {
      onError("Completa todos los campos.");
      return;
    }

    if (pass != pass2) {
      onError("Las contraseñas no coinciden.");
      return;
    }

    try {
      // Registro en Firebase
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      // Actualiza nombre (puedes guardar teléfono y género en Firestore después)
      await cred.user!.updateDisplayName(name);
      await cred.user!.reload();

      // Registro exitoso
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

  // ======== Google Sign-In (placeholder) ========
  Future<void> signInWithGoogle() async {
    // TODO: Implementar lógica real con Google Sign-In
    onError("Google Sign-In aún no está implementado.");
  }

  // ======== Facebook Sign-In (placeholder) ========
  Future<void> signInWithFacebook() async {
    // TODO: Implementar lógica real con Facebook Sign-In
    onError("Facebook Sign-In aún no está implementado.");
  }

  // ======== Apple Sign-In (placeholder) ========
  Future<void> signInWithApple() async {
    // TODO: Implementar lógica real con Apple Sign-In
    onError("Apple Sign-In aún no está implementado.");
  }
}
