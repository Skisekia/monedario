import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../models/user_model.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context, listen: false);
    final controller = SettingsController(context);
    final loading = context.watch<AuthController>().loading;
    final primaryColor = const Color(0xFF78A3EB);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<UserModel?>(
          future: auth.getCurrentUserModel(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(child: Text("No se pudo cargar el perfil"));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // ===== OPCIONES =====
                  _buildTile(
                    icon: Icons.download,
                    text: 'Descargar manual',
                    onTap: controller.downloadManual,
                    color: primaryColor,
                  ),
                  _buildTile(
                    icon: Icons.attach_money,
                    text: 'Cambiar tipo de moneda',
                    onTap: controller.changeCurrency,
                    color: primaryColor,
                  ),
                  _buildTile(
                    icon: Icons.history,
                    text: 'Historial de archivos',
                    onTap: controller.goToHistory,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 10),

                  // ===== CERRAR SESIÓN =====
                  _buildTile(
                    icon: Icons.logout,
                    text: 'Cerrar sesión',
                    onTap: () => controller.confirmLogout(() async {
                      await auth.signOut();
                      if (!context.mounted) return;
                      Navigator.pushNamedAndRemoveUntil(context, '/welcome', (_) => false);
                    }),
                    color: Colors.redAccent,
                    background: Colors.red.shade50,
                    trailing: loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : null,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Color color,
    Color? background,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: background ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(text),
        onTap: onTap,
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
