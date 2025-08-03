import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = false;
  bool get loading => _loading;
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  // ==========================
  // LOGIN EMAIL/PASSWORD
  // ==========================
  Future<void> login(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Error de autenticación');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ==========================
  // SIGN OUT
  // ==========================
  Future<void> signOut() async {
    final user = _auth.currentUser;
    if (user != null) {
      for (final info in user.providerData) {
        if (info.providerId == 'google.com') await GoogleSignIn().signOut();
        if (info.providerId == 'facebook.com') await FacebookAuth.instance.logOut();
      }
    }
    await _auth.signOut();
    notifyListeners();
  }

  // ==========================
  // OBTENER USUARIO ACTUAL
  // ==========================
  Future<UserModel?> getCurrentUserModel() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    String provider = 'email';
    final providerId =
        user.providerData.isNotEmpty ? user.providerData.first.providerId : '';
    if (providerId.contains("google")) provider = 'google';
    if (providerId.contains("facebook")) provider = 'facebook';
    if (providerId.contains("apple")) provider = 'apple';

    String? gender;
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      gender = doc.data()?['gender'];
    } catch (_) {
      gender = null;
    }

    return UserModel(
      name: user.displayName ?? '',
      email: user.email ?? '',
      gender: gender ?? '',
      provider: provider,
    );
  }

  // ==========================
  // REFRESCAR USUARIO
  // ==========================
  Future<void> refreshUser() async {
    final updatedUser = await getCurrentUserModel();
    if (updatedUser != null) {
      _userModel = updatedUser;
      notifyListeners();
    }
  }

  // ==========================
  // ACTUALIZAR PERFIL
  // ==========================
  Future<void> updateProfileData({
    String? newName,
    String? newPassword,
    String? newEmail,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final providerId =
        user.providerData.isNotEmpty ? user.providerData.first.providerId : '';

    // Bloquear cambios si es Google/Facebook
    if (providerId.contains("google") || providerId.contains("facebook")) {
      throw FirebaseAuthException(
        code: 'provider-linked',
        message:
            'Este perfil está vinculado a ${providerId.contains("google") ? "Google" : "Facebook"}. '
            'Debes cambiar tu información desde la cuenta vinculada.',
      );
    }

    // Cambiar nombre
    if (newName != null && newName.isNotEmpty && newName != user.displayName) {
      await user.updateDisplayName(newName);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'name': newName});
    }

    // Cambiar correo
    if (newEmail != null && newEmail.isNotEmpty && newEmail != user.email) {
      await user.verifyBeforeUpdateEmail(newEmail);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'email': newEmail});
    }

    // Cambiar contraseña
    if (newPassword != null && newPassword.isNotEmpty) {
      if (!_isPasswordStrong(newPassword)) {
        throw FirebaseAuthException(
          code: 'weak-password',
          message:
              'La contraseña debe tener al menos 6 caracteres, una mayúscula y un número.',
        );
      }
      await user.updatePassword(newPassword);
    }

    await refreshUser();
  }

  bool _isPasswordStrong(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasMinLength = password.length >= 6;
    return hasUppercase && hasNumber && hasMinLength;
  }

  // ==========================
  // LOGIN CON FACEBOOK
  // ==========================
  Future<void> loginWithFacebook({
    required Function(UserModel) onSuccess,
    required Function(String) onError,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      final result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final userCredential = await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          final docRef =
              FirebaseFirestore.instance.collection('users').doc(user.uid);
          final doc = await docRef.get();

          if (!doc.exists) {
            await docRef.set({
              'name': user.displayName ?? '',
              'email': user.email ?? '',
              'gender': '',
              'provider': 'facebook',
            });
          }

          final model = await getCurrentUserModel();
          if (model != null) {
            onSuccess(model);
          } else {
            onError('Error al obtener los datos del usuario.');
          }
        }
      } else {
        onError('Inicio cancelado o fallido.');
      }
    } catch (e) {
      onError('Error: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ==========================
  // RESTABLECER CONTRASEÑA
  // ==========================
  Future<void> sendPasswordResetEmail(
    String email, {
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'El correo no es válido.';
          break;
        case 'user-not-found':
          errorMessage = 'No existe una cuenta con este correo.';
          break;
        default:
          errorMessage = 'Ocurrió un error: ${e.message}';
      }
      onError(errorMessage);
    } catch (e) {
      onError('Error inesperado: $e');
    }
  }
}
