import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class RegisterController {
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final VoidCallback onSuccess;
  final Function(String) onError;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  RegisterController({
    required this.nameCtrl,
    required this.emailCtrl,
    required this.passCtrl,
    required this.onSuccess,
    required this.onError,
  });

  // ======= Registro manual por email =======
  Future<void> registerUser(BuildContext context) async {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      onError("Completa todos los campos.");
      return;
    }

    try {
      // Crear usuario en Firebase Auth
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      // Actualizar displayName
      await cred.user!.updateDisplayName(name);
      await cred.user!.reload();

      // Guardar datos en Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

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

  // ======= Guarda en Firestore si es usuario nuevo =======
  Future<void> _checkAndSaveUserData(User user) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // ======= Google Sign-In =======
  Future<void> signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut(); // fuerza selector de cuenta
      final googleUser = await GoogleSignIn(
        scopes: ['email'],
        signInOption: SignInOption.standard,
      ).signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      await _checkAndSaveUserData(result.user!);
      onSuccess();
    } catch (e) {
      onError("Error con Google Sign-In");
    }
  }

  // ======= Facebook Sign-In =======
  Future<void> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) {
        onError("Inicio con Facebook cancelado.");
        return;
      }
      final credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      final authResult = await _auth.signInWithCredential(credential);
      await _checkAndSaveUserData(authResult.user!);
      onSuccess();
    } catch (e) {
      onError("Error con Facebook Sign-In");
    }
  }

  // ======= Apple Sign-In =======
  Future<void> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ],
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final authResult = await _auth.signInWithCredential(oauthCredential);
      await _checkAndSaveUserData(authResult.user!);
      onSuccess();
    } catch (e) {
      onError("Error con Apple Sign-In");
    }
  }
}
