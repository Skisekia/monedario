import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../views/edit_profile_view.dart';
import '../views/history_view.dart';
import '../controllers/auth_controller.dart';

class SettingsController {
  final BuildContext context;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  SettingsController(this.context);

  // Muestra un cuadro de confirmación antes de cerrar sesión
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

  // Abre la vista para editar el perfil
  void goToEditProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileView()));
  }

  // Guarda y aplica el tipo de moneda seleccionado
  void changeCurrency(String currencyCode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Moneda cambiada a: $currencyCode')),
    );
    debugPrint("Nueva moneda seleccionada: $currencyCode");
  }

  // Guarda y aplica el idioma seleccionado
  void changeLanguage(String language) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Idioma cambiado a: $language')),
    );
    debugPrint("Nuevo idioma seleccionado: $language");
  }

  // Abre la vista con el historial de archivos del usuario
  void goToHistory() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryView()));
  }

  // Abre el enlace de redes sociales en el navegador o aplicación correspondiente
  Future<void> goToSocialLinks() async {
    const url = "https://tusredes.com";
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace')),
      );
    }
  }

  // Muestra un mensaje o redirige a la sección de soporte
  void goToHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ayuda y soporte próximamente')),
    );
  }

  // Conecta o desconecta la cuenta de Facebook
  Future<void> toggleFacebook(bool connect) async {
    if (connect) {
      try {
        final LoginResult result = await FacebookAuth.instance.login();
        if (!context.mounted) return;
        if (result.status == LoginStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cuenta de Facebook vinculada')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo vincular Facebook')),
          );
        }
      } catch (e) {
        debugPrint("Error vinculando Facebook: $e");
      }
    } else {
      await FacebookAuth.instance.logOut();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta de Facebook desconectada')),
      );
    }
  }

  // Conecta o desconecta la cuenta de Google
  Future<void> toggleGoogle(bool connect) async {
    if (connect) {
      try {
        final GoogleSignInAccount? account = await _googleSignIn.signIn();
        if (!context.mounted) return;
        if (account != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cuenta de Google vinculada')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo vincular Google')),
          );
        }
      } catch (e) {
        debugPrint("Error vinculando Google: $e");
      }
    } else {
      await _googleSignIn.signOut();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta de Google desconectada')),
      );
    }
  }

  // Actualiza la información del perfil del usuario
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

    // Actualiza el nombre
    if (name != user.displayName) {
      await user.updateDisplayName(name);
    }

    // Actualiza el email usando el método recomendado
    if (email != null && email.isNotEmpty && email != user.email) {
      await user.verifyBeforeUpdateEmail(email);
    }

    // Actualiza la contraseña si se proporciona
    if (password != null && password.isNotEmpty) {
      await user.updatePassword(password);
    }

    // Actualiza la foto de perfil
    if (imageFile != null) {
      try {
        final storageRef = _storage.ref().child('profiles/${user.uid}/profile.jpg');
        await storageRef.putFile(imageFile);
        final imageUrl = await storageRef.getDownloadURL();
        await user.updatePhotoURL(imageUrl);
        debugPrint("Imagen subida con éxito: $imageUrl");
      } catch (e) {
        debugPrint("Error subiendo imagen: $e");
      }
    }

    // Si se guarda género o país en Firestore, se podría actualizar aquí

    // Refresca la información del usuario en la aplicación
    if (!context.mounted) return;
    final authController = Provider.of<AuthController>(context, listen: false);
    await authController.refreshUser();
  }
}
