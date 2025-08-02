import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController {
  final BuildContext context;
  SettingsController(this.context);

  /// Ir a la vista de edición de perfil
  void goToEditProfile() {
    Navigator.pushNamed(context, '/edit_profile');
  }

  /// Ir a historial de archivos
  void goToHistory() {
    Navigator.pushNamed(context, '/history');
  }

  /// Guardar tipo de moneda globalmente
  Future<void> changeCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', currency);
  }

  /// Guardar idioma globalmente
  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
  }

  /// Confirmar cierre de sesión
  void confirmLogout(Future<void> Function() onConfirm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Seguro que quieres cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await onConfirm();
            },
            child: const Text("Cerrar sesión"),
          ),
        ],
      ),
    );
  }
}
