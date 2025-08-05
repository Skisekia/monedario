import 'package:flutter/material.dart';

import '../../utils/button_nav_bar.dart';
import '../../utils/modals_nav.dart';

import 'balance_view.dart';
import 'transaction_form_view.dart';
import 'home_view.dart';
import 'friends_view.dart';
import 'settings_view.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 2; // Home

  // Orden original: Balance(0) – Cartera(1) – Home(2) – Amigos(3) – Settings(4)
  // No agregamos nuevas vistas para no romper la barra
  static final List<Widget> _views = [
    BalanceView(),
    TransactionFormView(), // “Cartera” o transacciones
    HomeView(),
    FriendsView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _views[_selectedIndex],
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          // ────────── Pulsan el botón central (+ / Home) ──────────
          if (index == 2) {
            switch (_selectedIndex) {
              case 0:
                showBalanceActionsModal(context);
                return;
              case 1:
                showTransactionActionsModal(context);
                return;
              case 3:
                showFriendsActionsModal(context);
                return;
              case 4:
                // Desde Settings vuelve a Home
                setState(() => _selectedIndex = 2);
                return;
              default:
                return; // Ya estás en Home
            }
          }
          // Cambio normal de pestaña
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
