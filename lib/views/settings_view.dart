import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../models/user_model.dart';
import '../../utils/icon_mapper.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context, listen: false);
    final controller = SettingsController(context);
    final loading = context.watch<AuthController>().loading;

    const primaryColor = Color(0xFF78A3EB);

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

            final user = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // ===== HEADER CURVO AZUL CON PERFIL Y BOTÓN =====
                  Stack(
                    children: [
                      // Curva azul
                      ClipPath(
                        clipper: _CurveClipper(),
                        child: Container(
                          height: 280,
                          color: primaryColor,
                        ),
                      ),
                      // Contenido centralizado en la zona azul
                      Container(
                        height: 280,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipOval(
                              child: Container(
                                width: 100,
                                height: 100,
                                color: Colors.white,
                                child: Image.asset(
                                  getProfileIconByGender(user.gender),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover ,// Ajustar imagen al círculo,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              user.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user.email,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: controller.goToEditProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 10,
                                ),
                              ),
                              child: const Text('Editar perfil'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // ===== OPCIONES =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildOptionTile(
                          icon: Icons.download,
                          text: 'Descargar manual',
                          color: primaryColor,
                          onTap: controller.downloadManual,
                        ),
                        _buildOptionTile(
                          icon: Icons.attach_money,
                          text: 'Cambiar tipo de moneda',
                          color: primaryColor,
                          onTap: controller.changeCurrency,
                        ),
                        _buildOptionTile(
                          icon: Icons.history,
                          text: 'Historial de archivos',
                          color: primaryColor,
                          onTap: controller.goToHistory,
                        ),
                        _buildOptionTile(
                          icon: Icons.help_outline,
                          text: 'Ayuda y soporte',
                          color: primaryColor,
                          onTap: controller.goToHelp,
                        ),

                        const SizedBox(height: 30),

                        // ===== BOTÓN CERRAR SESIÓN =====
                        ElevatedButton.icon(
                          icon: const Icon(Icons.logout),
                          label: loading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white),
                                )
                              : const Text('Cerrar sesión'),
                          onPressed: () => controller.confirmLogout(() async {
                            await auth.signOut();
                            if (!context.mounted) return;
                            // Redirigir a la pantalla de bienvenida
                            Navigator.pushNamedAndRemoveUntil(
                              context, '/welcome', (_) => false);
                          }),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(text),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

// Clipper para la curva superior del header
class _CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2, size.height, size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
