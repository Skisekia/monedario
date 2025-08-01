import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../models/user_model.dart';
import '../../utils/icon_mapper.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    const gradientColors = [
      Color(0xFF250E2C),
      Color(0xFF837AB6),
      Color(0xFFF6A5C0),
    ];

    final auth = Provider.of<AuthController>(context, listen: false);
    final controller = SettingsController(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<UserModel?>(
          future: auth.getCurrentUserModel(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final user = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // ===== ENCABEZADO =====
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Fondo degradado
                      Container(
                        height: 220,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                      ),

                      // Botón Logout (puedes quitar el back porque navegas desde el nav bar)
                      Positioned(
                        top: 12,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: () => controller.confirmLogout(() async {
                            await auth.signOut();
                            if (!context.mounted) return;
                            Navigator.pushNamedAndRemoveUntil(
                              context, '/welcome', (_) => false);
                          }),
                        ),
                      ),

                      // Avatar + Botón editar
                      Positioned(
                        top: 60,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 4),
                                  ),
                                  child: ClipOval(
                                    child: Lottie.asset(
                                      getProfileIconByGender(user.gender),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: controller.goToEditProfile,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      child: const Icon(Icons.edit,
                                          size: 18,
                                          color: Color(0xFF837AB6)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              user.email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 80),

                  // ===== OPCIONES EN CUADRÍCULA =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildGridOption(Icons.download, 'Descargar manual',
                            controller.downloadManual),
                        _buildGridOption(Icons.attach_money,
                            'Cambiar tipo de moneda', controller.changeCurrency),
                        _buildGridOption(Icons.history, 'Historial de archivos',
                            controller.goToHistory),
                        _buildGridOption(Icons.help_outline, 'Ayuda y soporte',
                            controller.goToHelp),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridOption(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100, // Fondo neutro
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: const Color(0xFF837AB6)),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
