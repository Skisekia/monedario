import 'package:flutter/material.dart';
import '../../utils/app_header.dart';
import '../../utils/button_nav_bar.dart';

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

  // Tus páginas reales
  static const List<Widget> _views = [
    SizedBox(), // Dashboard/Home (contenido principal lo agregas aquí)
    StatisticsView(),
    TransactionFormView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Header dinámico
            AppHeader(currentIndex: _selectedIndex),

            // 🔹 Vista seleccionada
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _views,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
