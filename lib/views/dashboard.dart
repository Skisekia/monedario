import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import '../../utils/button_nav_bar.dart';

import 'home_view.dart';
import 'statistics_view.dart';
import 'transaction_form_view.dart';
import 'settings_view.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  // Las cuatro vistas que corresponderán a cada pestaña
  static const List<Widget> _views = [
    HomeView(),
    StatisticsView(),
    TransactionFormView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No hay encabezado ni avatar aquí; cada vista se encarga de mostrar lo suyo
      body: SafeArea(
        child: _views[_selectedIndex],
      ),
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
