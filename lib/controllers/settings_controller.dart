import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import '../views/edit_profile_view.dart';
import '../views/history_view.dart';
import '../controllers/auth_controller.dart';

class SettingsController {
  final BuildContext context;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  SettingsController(this.context);

  // ==============================
  // Confirmar logout
  // ==============================
  void confirmLogout(Function onConfirm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ==============================
  // Navegar a editar perfil
  // ==============================
  void goToEditProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileView()));
  }

  // ==============================
  // Snackbar simulando descarga
  // ==============================
  void downloadManual() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Descargando manual...')),
    );
  }

  void changeCurrency() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cambiando tipo de moneda...')),
    );
  }

  void goToHistory() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryView()));
  }

  void goToHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ayuda y soporte próximamente')),
    );
  }

  // ==============================
  // Actualizar datos del perfil
  // ==============================
  Future<void> updateProfile({
    required String name,
    String? email,
    String? password,
    String? gender,
    String? country,
    File? imageFile,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Actualiza nombre
    if (name != user.displayName) {
      await user.updateDisplayName(name);
    }

    // Actualiza email
    if (email != null && email.isNotEmpty && email != user.email) {
      await user.updateEmail(email);
    }

    // Actualiza contraseña
    if (password != null && password.isNotEmpty) {
      await user.updatePassword(password);
    }

    // Actualiza foto
    if (imageFile != null) {
  try {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profiles/${user.uid}/profile.jpg');

    // Subir archivo
    await storageRef.putFile(imageFile);

    // Obtener URL pública
    final imageUrl = await storageRef.getDownloadURL();

    // Actualizar en Firebase Auth
    await user.updatePhotoURL(imageUrl);

    debugPrint("Imagen subida con éxito: $imageUrl");
  } catch (e) {
    debugPrint("Error subiendo imagen: $e");
  }
}


    // Opcional: si usas Firestore, actualiza género y país
    if (gender != null || country != null) {
      final firestore = FirebaseStorage.instance;
      final uid = user.uid;
      final doc = firestore.ref().child('users').child(uid);
      final updateData = <String, dynamic>{};

      if (gender != null) updateData['gender'] = gender;
      if (country != null) updateData['country'] = country;

      if (updateData.isNotEmpty) {
        // Asegúrate de tener configurado Firestore y el doc de usuario
        // await FirebaseFirestore.instance.collection('users').doc(uid).update(updateData);
      }
    }

    // Actualizar en memoria el modelo global
    final authController = Provider.of<AuthController>(context, listen: false);
    await authController.refreshUser();
  }
}
