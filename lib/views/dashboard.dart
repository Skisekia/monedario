import 'package:flutter/material.dart';

import '../../utils/button_nav_bar.dart';
import '../../utils/modals_nav.dart';

import 'balance_view.dart';
import 'transaction_form_view.dart';  // pestaña “Transacciones / Cartera”
import 'home_view.dart';
import 'friends_view.dart';
import 'settings_view.dart';

//dashboard de navegación principal
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  // Callback estático para cambiar de pestaña desde otras vistas 
  static void Function(int)? changeTabExternal;

  // Método estático para cambiar de pestaña desde fuera del Dashboard
  @override
  State<Dashboard> createState() => DashboardState();
}


// Estado del Dashboard
class DashboardState extends State<Dashboard> {
  int _selectedIndex = 2; // Home al arrancar

  // Pestañas fijas en la barra
  // Estas son las vistas que se mostrarán en el Dashboard
  static final List<Widget> _views = [
    BalanceView(),
    TransactionsView(),
    HomeView(),
    FriendsView(),
    SettingsView(),
  ];

// Método para cambiar de pestaña desde fuera del Dashboard
  @override
  void initState() {
    super.initState();
    // Asigna el callback estático para cambiar tab desde fuera
    Dashboard.changeTabExternal = (int index) {
      if (mounted) {
        setState(() => _selectedIndex = index);
      }
    };
  }

// Método para construir el widget
  @override
  void dispose() {
    // Limpia el callback cuando se elimina el dashboard
    if (Dashboard.changeTabExternal != null) {
      Dashboard.changeTabExternal = null;
    }
    super.dispose();
  }

// Método para construir el widget
  @override
  //
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar personalizada
      body: _views[_selectedIndex],
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          // Pulsan el botón central (+ / Home)
          if (index == 2) {
            switch (_selectedIndex) {
              // Si ya estás en Home, muestra el modal de acciones
              case 0:
                showBalanceActionsModal(context);
                return;
                // Si está en Transacciones, muestra el modal de acciones
              case 1:
                showTransactionActionsModal(context);
                return;
              case 3:
              // Si está en Amigos, muestra el modal de acciones
                showFriendsActionsModal(context);
                return;
              case 4: // Settings → vuelve a Home
                setState(() => _selectedIndex = 2);
                return;
              default:
                return; // Ya esta en Home
            }
          }
          // Cambio normal de pestaña
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
