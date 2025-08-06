// 📄 lib/widgets/app_header.dart
import 'package:flutter/material.dart';

// Header corporativo reutilizable
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onHomeTap;
  final VoidCallback? onNotifTap;
  final VoidCallback? onBackTap;      // ← NUEVO
  final bool showHome;
  final bool showNotif;
  final bool showBack;                // ← NUEVO

  const AppHeader({
    this.onHomeTap,
    this.onNotifTap,
    this.onBackTap,
    this.showHome = true,
    this.showNotif = false,
    this.showBack = false,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 18, left: 12, right: 12, bottom: 8),
        child: Row(
          children: [
            if (showBack)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF837AB6)),
                onPressed: onBackTap ?? () => Navigator.pop(context),
                tooltip: 'Atrás',
              )
            else if (showHome)
              IconButton(
                icon: const Icon(Icons.home_rounded,
                    color: Color(0xFF837AB6)),
                onPressed: onHomeTap,
                tooltip: 'Inicio',
              ),
            const Spacer(),
            if (showNotif)
              IconButton(
                icon: const Icon(Icons.notifications_rounded,
                    color: Color(0xFF837AB6)),
                onPressed: onNotifTap,
                tooltip: 'Notificaciones',
              ),
          ],
        ),
      ),
    );
  }
}
