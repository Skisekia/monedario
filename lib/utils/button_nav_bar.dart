// lib/utils/button_nav_bar.dart
import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const gradientColors = [
      Color(0xFF250E2C),
      Color(0xFF837AB6),
      Color(0xFFF6A5C0),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16), // 🔹 Lo eleva un poco
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20), // 🔹 Un poco de margen lateral
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40), // 🔹 Bordes redondeados del nav
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Inicio', 0, gradientColors),
            _buildNavItem(Icons.bar_chart_rounded, 'Estadísticas', 1, gradientColors),
            _buildNavItem(Icons.account_balance_wallet_rounded, 'Cartera', 2, gradientColors),
            _buildNavItem(Icons.person_rounded, 'Perfil', 3, gradientColors), // cambiado
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, int index, List<Color> gradientColors) {
    final bool isSelected = selectedIndex == index;

    if (isSelected) {
      // Botón seleccionado tipo globo con gradiente
      return GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Botón no seleccionado simple
      return GestureDetector(
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.grey, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }
  }
}
