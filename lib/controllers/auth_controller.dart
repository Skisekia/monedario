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
  // Login email/contraseña (opcional si usa local) 
  Future<void> login(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  //  SignOut general
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

  // Obtener modelo de usuario desde FirebaseAuth y Firestore
  Future<UserModel?> getCurrentUserModel() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    String provider = 'email';
    final providerId = user.providerData.isNotEmpty ? user.providerData.first.providerId : '';
    if (providerId.contains("google")) provider = 'google';
    if (providerId.contains("facebook")) provider = 'facebook';
    if (providerId.contains("apple")) provider = 'apple';

    String? gender;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
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
  /// Navega a EditProfileView
  Future<void> refreshUser() async {
  final updatedUser = await getCurrentUserModel();
  if (updatedUser != null) {
    _userModel = updatedUser;
    notifyListeners();
  }
}


  // Facebook Login
  Future<void> loginWithFacebook({
    required Function(UserModel) onSuccess,
    required Function(String) onError,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      final result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final credential = FacebookAuthProvider.credential(result.accessToken!.token);
        final userCredential = await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
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

  // Recuperar contraseña
  // Envío de enlace de restablecimiento de contraseña
Future<void> sendPasswordResetEmail(String email, {
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