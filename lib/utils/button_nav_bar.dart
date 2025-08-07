import 'package:flutter/material.dart';
import '../ui/theme.dart'; // importa tu archivo de colores

// Barra de navegación personalizada
// Esta barra de navegación incluye un botón central y un diseño personalizado
class AppBottomNavBar extends StatelessWidget {
  // Índice de la pestaña seleccionada
  // Este índice se usa para resaltar la pestaña activa
  final int selectedIndex;
  final ValueChanged<int> onTap;

// Constructor que recibe el índice seleccionado y la función de callback
  // onTap se llama cuando se pulsa una pestaña
  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

// Construye la barra de navegación
  // Contiene los iconos y etiquetas de cada pestaña
  @override
  Widget build(BuildContext context) {
    const gradientColors = [
      Color(0xFF250E2C),
      Color(0xFF837AB6),
      Color(0xFFF6A5C0),
    ];
    // Determina si el botón central es Home o Add según la pestaña seleccionada
    // Si está en Home o Settings, muestra el icono de Home, de lo contrario muestra el icono de Add
    final bool isHomeOrSettings = selectedIndex == 2 || selectedIndex == 4;

    // Retorna un Container con el diseño de la barra de navegación
    // Contiene un Row con los iconos de las pestañas y un botón central
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12, blurRadius: 16, offset: Offset(0, -2)),
        ],
          // Elimina el borde superior para que no se vea en la parte superior
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: 76,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Iconos de las pestañas
                // Cada icono es un 'vinculo' que llama a onTap con el índice correspondiente
                _buildNavItem(Icons.account_balance_rounded, "Balance", 0, gradientColors),
                _buildNavItem(Icons.account_balance_wallet_rounded, "Cartera", 1, gradientColors),
                const SizedBox(width: 72),
                _buildNavItem(Icons.people_alt_rounded, "Amigos", 3, gradientColors),
                _buildNavItem(Icons.settings, "Ajustes", 4, gradientColors),
              ],
            ),
          ),
          // FAB central solo con color solido
          Positioned(
            top: -38,
            left: 0,
            right: 0,
            child: Center(
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => onTap(2),
                child: Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cardMain, // Color del botón central
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33837AB6),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    isHomeOrSettings ? Icons.home_rounded : Icons.add,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Construye un elemento de navegación
// Recibe el icono, etiqueta, índice y colores del degradado
  Widget _buildNavItem(
      IconData icon, String label, int index, List<Color> gradientColors) {
    final bool isSelected = selectedIndex == index;

// Retorna un vinculo que detecta pulsaciones
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(26),
      child: isSelected
      // Si la pestaña está seleccionada, muestra un botón con degradado
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 24),
                  const SizedBox(width: 6),
                  Text(label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ],
              ),
            )
            // Si no está seleccionada, muestra un botón simple
            : Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.grey, size: 24),
                  const SizedBox(height: 2),
                  Text(label,
                      style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
    );
  }
}
