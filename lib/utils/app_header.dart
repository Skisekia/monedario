import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../utils/icon_mapper.dart';

class AppHeader extends StatelessWidget {
  final bool isHome;                   // True = dashboard, False = otras vistas
  final VoidCallback? onHomeTap;       // Para cuando el usuario toca el icono de Home
  final VoidCallback? onNotifTap;      // Para cuando toca notificaciones

  const AppHeader({
    super.key,
    this.isHome = false,
    this.onHomeTap,
    this.onNotifTap,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      // Puedes personalizar el color de fondo aquí si tu diseño lo necesita
      child: FutureBuilder<UserModel?>(
        future: auth.getCurrentUserModel(),
        builder: (context, snapshot) {
          Widget leftWidget;

          // Si es Home: Avatar + mensaje
          if (isHome && snapshot.hasData) {
            final user = snapshot.data!;
            leftWidget = Row(
              children: [
                SizedBox(
                  width: 52,
                  height: 52,
                  child: getProfileIconWidget(
                    user.gender,
                    customAsset: user.profileIconAsset,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "¡Bienvenido!",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            // Si NO es home: mostrar icono de Home
            leftWidget = IconButton(
              icon: const Icon(Icons.home_rounded, size: 36, color: Colors.black87),
              onPressed: onHomeTap ?? () {
                // Por defecto navega al dashboard/home
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leftWidget,
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, size: 30, color: Colors.black87),
                onPressed: onNotifTap ?? () {
                  // Aquí  la navegación a notificaciones
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
