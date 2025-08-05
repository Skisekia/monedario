import 'package:flutter/material.dart';

//header de la app, reutilizable en varias pantallas
class AppHeader extends StatelessWidget {
  final VoidCallback? onHomeTap;
  final VoidCallback? onNotifTap;
  final bool showHome;
  final bool showNotif;
// Constructor con parámetros opcionales
  const AppHeader({
    this.onHomeTap,
    this.onNotifTap,
    this.showHome = true,
    this.showNotif = false,
    super.key,
  });
// Constructor con parámetros obligatorios
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 18, left: 12, right: 12, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showHome)
              IconButton(
                icon: const Icon(Icons.home_rounded, color: Color(0xFF837AB6)),
                onPressed: onHomeTap,
                tooltip: 'Ir al inicio',
              ),
            const Spacer(),
            if (showNotif)
              IconButton(
                icon: const Icon(Icons.notifications_rounded, color: Color(0xFF837AB6)),
                onPressed: onNotifTap,
                tooltip: 'Notificaciones',
              ),
          ],
        ),
      ),
    );
  }
}
