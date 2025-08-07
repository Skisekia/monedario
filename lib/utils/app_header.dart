// 📄 lib/utils/app_header.dart
import 'package:flutter/material.dart';

/// Header corporativo reutilizable
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onHomeTap;
  final VoidCallback? onNotifTap;
  final VoidCallback? onBackTap;
  final VoidCallback? onCalendarTap;
  final VoidCallback? onSearchTap;

  final bool showHome;
  final bool showNotif;
  final bool showBack;
  final bool showCalendar;
  final bool showSearch;

  const AppHeader({
    super.key,
    this.onHomeTap,
    this.onNotifTap,
    this.onBackTap,
    this.onCalendarTap,
    this.onSearchTap,
    this.showHome     = true,
    this.showNotif    = false,
    this.showBack     = false,
    this.showCalendar = false,
    this.showSearch   = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(top: top, left: 12, right: 12, bottom: 8),
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
                icon: const Icon(Icons.home_rounded, color: Color(0xFF837AB6)),
                onPressed: onHomeTap,
                tooltip: 'Inicio',
              ),

            const Spacer(),

            if (showSearch)
              IconButton(
                icon: const Icon(Icons.search_rounded,
                    color: Color(0xFF837AB6)),
                onPressed: onSearchTap,
                tooltip: 'Buscar',
              ),
            if (showCalendar)
              IconButton(
                icon: const Icon(Icons.calendar_today_rounded,
                    color: Color(0xFF837AB6)),
                onPressed: onCalendarTap,
                tooltip: 'Calendario',
              ),
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
