// 📄 lib/views/dashboard.dart
import 'package:flutter/material.dart';

import '../../utils/button_nav_bar.dart';
import '../../utils/modals_nav.dart';

import 'balance_view.dart';
import 'transaction_form_view.dart';  // pestaña “Transacciones / Cartera”
import 'home_view.dart';
import 'friends_view.dart';
import 'settings_view.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 2; // Home al arrancar

  // ────── Pestañas fijas en la barra ──────
  // 0-Balance | 1-Transacciones | 2-Home(+) | 3-Friends | 4-Settings
  static final List<Widget> _views = [
    BalanceView(),
    TransactionFormView(),
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
              case 4: // Settings → vuelve a Home
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
