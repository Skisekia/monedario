import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/notifications_view.dart';
import '../models/user_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login de usuario
  Future<void> login(
    String email,
    String password,
    BuildContext context, {
  // Esta función se usa para iniciar sesión
    required bool Function() mounted,
  }) async {
    // Verifica que el usuario esté montado antes de mostrar notificaciones
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Verifica si el usuario está verificado
      final user = userCredential.user;
      if (user != null && !user.emailVerified) {
        // Si no está verificado, cierra sesión y muestra notificación
        await _auth.signOut();
        if (mounted()) {
          showErrorNotification(
            context,
            "Debes verificar tu correo antes de iniciar sesión. Revisa tu bandeja de entrada.",
          );
        }
        return;
      }
      if (mounted()) {
        showSuccessNotification(context, "¡Bienvenido de nuevo!");
        // Aquí navega a la pantalla principal o donde sea necesario
      }
    } on FirebaseAuthException catch (e) {
      if (mounted()) {
        if (e.code == 'invalid-email') {
          showErrorNotification(context, "El correo electrónico no es válido.");
        } else if (e.code == 'user-disabled') {
          showErrorNotification(context, "La cuenta ha sido deshabilitada.");
        } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          showErrorNotification(context, "Correo o contraseña incorrectos.");
        } else {
          showErrorNotification(context, "Ocurrió un error. Intenta de nuevo.");
        }
      }
    } catch (_) {
      if (mounted()) {
        showErrorNotification(context, "Error desconocido. Intenta más tarde.");
      }
    }
  }

  // Registro de usuario
  Future<void> register(
    String email,
    String password,
    BuildContext context, {
  // Esta función se usa para registrar un nuevo usuario
    required bool Function() mounted,
  }) async {
    try {
      // Crea un nuevo usuario
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Envía un correo de verificación
      await userCredential.user?.sendEmailVerification();
      if (mounted()) {
        showSuccessNotification(
          context,
          "¡Registro exitoso! Verifica tu correo antes de iniciar sesión.",
        );
      }
      // Mensaje de éxito y redirigir al login si es necesario
    } on FirebaseAuthException catch (e) {
      if (mounted()) {
        if (e.code == 'email-already-in-use') {
          showErrorNotification(context, "Ya existe una cuenta con este correo.");
        } else if (e.code == 'invalid-email') {
          showErrorNotification(context, "El correo electrónico no es válido.");
        } else if (e.code == 'weak-password') {
          showErrorNotification(context, "La contraseña es muy débil.");
        } else {
          showErrorNotification(context, "No se pudo completar el registro.");
        }
      }
      // Manejo de errores específicos de FirebaseAuth
    } catch (_) {
      if (mounted()) {
        showErrorNotification(context, "Error desconocido. Intenta más tarde.");
      }
    }
  }

  // Resetear contraseña
  Future<void> resetPassword(
    String email,
    // Esta función se usa para enviar un correo de restablecimiento de contraseña
    BuildContext context, {
    required bool Function() mounted,
    // Asegura que el usuario esté montado antes de mostrar notificaciones
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      // Notifica al usuario que se envió el correo
      if (mounted()) {
        showSuccessNotification(
          context,
          "Te hemos enviado un correo para restablecer tu contraseña.",
        );
      }
      //



    } on FirebaseAuthException catch (e) {
      if (mounted()) {
        if (e.code == 'user-not-found') {
          showErrorNotification(context, "No existe una cuenta con ese correo.");
        } else if (e.code == 'invalid-email') {
          showErrorNotification(context, "El correo electrónico no es válido.");
        } else {
          showErrorNotification(context, "No se pudo enviar el correo. Intenta de nuevo.");
        }
      }
      // Manejo de errores específicos de FirebaseAuth
    } catch (_) {
      if (mounted()) {
        showErrorNotification(context, "Error desconocido. Intenta más tarde.");
      }
    }
  }

  // Cerrar sesión y muestra notificación
  Future<void> signOut(
    BuildContext context, {
    required bool Function() mounted,
  }) async {
    try {
      await _auth.signOut();
      if (mounted()) {
        showSuccessNotification(context, "Sesión cerrada correctamente.");
        // Redirige al login o pantalla inicial si es necesario
      }
    } catch (_) {
      if (mounted()) {
        showErrorNotification(context, "No se pudo cerrar sesión. Intenta de nuevo.");
      }
    }
  }

  // Reenviar correo de verificación 
  Future<void> resendEmailVerification(
    BuildContext context, {
    required bool Function() mounted,
  }) async {
    try {
      // Verifica que el usuario esté autenticado
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        if (mounted()) {
          showSuccessNotification(context, "Correo de verificación reenviado.");
        }
      } else {
        if (mounted()) {
          showErrorNotification(context, "El usuario no está autenticado o ya está verificado.");
        }
      }
    } catch (_) {
      if (mounted()) {
        showErrorNotification(context, "No se pudo reenviar el correo de verificación.");
      }
    }
  }

  // GETTERS RÁPIDOS
  User? get currentUser => _auth.currentUser;

// Verifica si el usuario está autenticado
  bool get isLoggedIn => _auth.currentUser != null;

  Future<bool> isEmailVerified() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      return user.emailVerified;
    }
    return false;
  }

  // OBTENER USERMODEL DE FIRESTORE
  Future<UserModel?> getCurrentUserModel() async {
  final user = _auth.currentUser;
  if (user == null) return null;

// Intenta obtener el usuario de Firestore
  // Si no existe, regresa el usuario de FirebaseAuth
  try {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      return UserModel(
        name: data['name'] ?? user.displayName ?? '',
        email: data['email'] ?? user.email ?? '', 
        gender: data['gender'] ?? '',
        provider: data['provider'] ?? '',
        profileIconAsset: data['profileIconAsset'],
        balance: (data['balance'] != null)
            ? (data['balance'] is int ? (data['balance'] as int).toDouble() : data['balance'] as double)
            : 0.0,
        photoUrl: data['photoUrl'], // se lee la foto del usuario
      );
    }
    // Si no existe en Firestore, regresa el usuario de Auth
    return UserModel(
      name: user.displayName ?? '',
      email: user.email ?? '',
      gender: '',
      provider: '',
      profileIconAsset: null,
      balance: 0.0,
      photoUrl: null,
    );
  } catch (e) {
    // Puedes loggear el error
    return null;
  }
}

// ACTUALIZAR DATOS DE PERFIL
  Future<void> updateProfileData({
  required String newName,
  String? newPassword,
}) async {
  final user = _auth.currentUser;
  if (user == null) throw FirebaseAuthException(code: 'no-user', message: 'No hay usuario autenticado.');

  // Actualiza nombre en FirebaseAuth y Firestore
  await user.updateDisplayName(newName);
  await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
    'name': newName,
  });

  // Actualiza la contraseña si se proporciona
  if (newPassword != null && newPassword.isNotEmpty) {
    await user.updatePassword(newPassword);
  }
}

}
