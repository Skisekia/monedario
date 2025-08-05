import 'package:flutter/material.dart';
import '../utils/app_header.dart'; // Ajusta la ruta si es necesario

class BalanceView extends StatelessWidget {
  const BalanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppHeader(
          showHome: true, // Cambia a false si no se quiere mostrar el icono home
         onHomeTap: () {
          // Navega a la vista de inicio
          Navigator.pushNamedAndRemoveUntil(context, '/home_view', (route) => true);
        },

        ),
        const Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance_rounded, size: 80, color: Color(0xFF837AB6)),
                SizedBox(height: 20),
                Text(
                  "Balance General",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Aquí verás tus estadísticas y gráficos.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
