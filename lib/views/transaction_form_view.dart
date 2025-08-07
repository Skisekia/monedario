import 'package:flutter/material.dart';
import '../utils/app_header.dart'; // Ajusta la ruta si es diferente

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppHeader(
          showHome: true,
          onHomeTap: () {
            Navigator.pushNamedAndRemoveUntil(context, '/home_view', (route) => true);
          },
        ),
        const Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.swap_horiz_rounded, size: 80, color: Color(0xFF837AB6)),
                SizedBox(height: 20),
                Text(
                  "Transacciones",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Aquí verás tu historial de movimientos.",
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
