import 'package:flutter/material.dart';
//import '../../controllers/auth_controller.dart';
import '../../views/edit_profile_view.dart';
import '../../views/history_view.dart';

class SettingsController {
  final BuildContext context;

  SettingsController(this.context);

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

  void goToEditProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileView()));
  }

  void goToHistory() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryView()));
  }

  void downloadManual() {
    // Lógica futura para descargar el manual
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Descargando manual... (función futura)')),
    );
  }

  void changeCurrency() {
    // Lógica futura
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cambio de moneda... (función futura)')),
    );
  }
}
