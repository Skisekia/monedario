import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../utils/icon_mapper.dart';

class AppHeader extends StatelessWidget {
  final bool showAvatar;
  final bool showWelcome;
  final bool showBackButton;
  final String? rightIconAsset;         // Ej: 'assets/icons/notification.png'
  final IconData? rightIconData;        // Alternativa si usas iconos nativos
  final VoidCallback? onRightIconTap;
  final VoidCallback? onBackTap;
  final String? customWelcome;          // Ej: "Hola,"
  final Color? backgroundColor;

  const AppHeader({
    super.key,
    this.showAvatar = true,
    this.showWelcome = true,
    this.showBackButton = false,
    this.rightIconAsset,
    this.rightIconData,
    this.onRightIconTap,
    this.onBackTap,
    this.customWelcome,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context, listen: false);

    return Container(
      color: backgroundColor ?? Colors.transparent,
      padding: const EdgeInsets.only(top: 36, left: 20, right: 20, bottom: 18),
      child: FutureBuilder<UserModel?>(
        future: auth.getCurrentUserModel(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 62,
              child: Align(
                alignment: Alignment.centerLeft,
                child: LinearProgressIndicator(),
              ),
            );
          }
          final user = snapshot.data;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Botón de Back o Avatar
              if (showBackButton)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 28),
                  onPressed: onBackTap ?? () => Navigator.of(context).pop(),
                )
              else if (showAvatar && user != null)
                SizedBox(
                  width: 52, height: 52,
                  child: getProfileIconWidget(
                    user.gender,
                    customAsset: user.profileIconAsset,
                  ),
                )
              else
                const SizedBox(width: 52), // Placeholder para alineación

              const SizedBox(width: 16),

              // Mensaje de bienvenida y nombre
              if (showWelcome && user != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customWelcome ?? "Hello,",
                        style: const TextStyle(
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
                )
              else
                const Spacer(),

              // Ícono derecho
              if (rightIconAsset != null)
                GestureDetector(
                  onTap: onRightIconTap,
                  child: Image.asset(
                    rightIconAsset!,
                    width: 28, height: 28,
                  ),
                )
              else if (rightIconData != null)
                IconButton(
                  icon: Icon(rightIconData, size: 28),
                  onPressed: onRightIconTap,
                )
              else
                const SizedBox(width: 28), // Placeholder para alineación
            ],
          );
        },
      ),
    );
  }
}
