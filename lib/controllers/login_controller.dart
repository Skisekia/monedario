import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

  // ======= Guarda en Firestore si es nuevo =======
  Future<void> _checkAndSaveUserData(User user) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'gender': 'Otro',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // ======= Google =======
  Future<void> signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut(); // fuerza selector de cuenta
      final googleUser = await GoogleSignIn().signIn();
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

  // ======= Facebook =======
  Future<void> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) {
        onError("Inicio con Facebook cancelado.");
        return;
      }
      final credential = FacebookAuthProvider.credential(result.accessToken!.token);
      final authResult = await _auth.signInWithCredential(credential);
      await _checkAndSaveUserData(authResult.user!);
      onSuccess();
    } catch (e) {
      onError("Error con Facebook Sign-In");
    }
  }

  // ======= Apple =======
  Future<void> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
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
