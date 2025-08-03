import 'package:flutter/material.dart';
import 'package:monedario/utils/modals_view.dart'; // Ajusta la ruta si es necesario
import '../../utils/button_nav_bar.dart';
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

  static final List<Widget> _views = [
    BalanceView(),           // 0
    TransactionFormView(),   // 1
    HomeView(),              // 2
    FriendsView(),           // 3
    SettingsView(),          // 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _views[_selectedIndex],
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            if (_selectedIndex == 2) {
              // Ya estás en Home: NO hace nada
              return;
            }
            if (_selectedIndex == 4) {
              // Desde Settings: te regresa a Home
              setState(() => _selectedIndex = 2);
              return;
            }
            // Si estás en la vista de Balance, muestra el modal de balance
            if (_selectedIndex == 0) {
              showBalanceActionsModal(context);
              return;
            }
            // Si estás en la vista de Amigos, muestra el modal de amigos
            if (_selectedIndex == 3) {
              showFriendsActionsModal(context);
              return;
            }
            // En otras vistas: muestra el modal de agregar clásico
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const ModalsView(),
            );
            return;
          }
          // Cambia de sección normalmente
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
