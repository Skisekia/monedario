import 'package:flutter/material.dart';
import 'dart:math';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final isTablet = w > 600;

    const backgroundColor = Color(0xFF78A3EB);
    const accentColor = Color(0xFF325DBB);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // ==== DECORACIÓN DE FONDO como burbuja de íconos ====
          ..._buildBackgroundPattern(
            centerX: w / 2 - 40,
            centerY: isTablet ? h * 0.18 : h * 0.15,
          ),

          // ==== CONTENIDO ====
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Imagen
                      SizedBox(
                        height: isTablet ? h * 0.48 : h * 0.40,
                        child: Image.asset(
                          'assets/welcome_cats.png',
                          fit: BoxFit.contain,
                          width: isTablet ? w * 0.65 : w * 0.8,
                        ),
                      ),
                      const SizedBox(height: 32),

                      Text(
                        'Bienvenido a',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: isTablet ? 26 : 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Monedario',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: isTablet ? 36 : 30,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Administra tus finanzas, controla tus deudas y lleva el control desde una sola app.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Botón Iniciar sesión
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: const Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Botón Crear cuenta
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pushNamed(context, '/register'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: accentColor, width: 2),
                            foregroundColor: accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: const Text(
                            'Crear cuenta',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      const Text(
                        'Al continuar aceptas nuestra Política de Privacidad y Términos de Servicio.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white60,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBackgroundPattern({required double centerX, required double centerY}) {
    //const iconColor = Colors.white24;
    const baseSize = 22.0;

    final icons = [
      Icons.attach_money,
      Icons.savings_outlined,
      Icons.account_balance,
      Icons.trending_up,
      Icons.wallet,
      Icons.bar_chart,
      Icons.pie_chart_outline,
      Icons.account_balance_wallet,
      Icons.payments_outlined,
      Icons.receipt_long,
      Icons.trending_down,
      Icons.currency_exchange,
      Icons.price_change,
    ];

    final List<Offset> positions = [
      const Offset(-80, -40),
      const Offset(0, -70),
      const Offset(80, -40),
      const Offset(140, 0),
      const Offset(100, 60),
      const Offset(30, 90),
      const Offset(-50, 100),
      const Offset(-100, 30),
      const Offset(-120, -20),
      const Offset(160, -30),
      const Offset(180, 50),
      const Offset(-150, 60),
      const Offset(-60, -60),
      const Offset(60, -100),
    ];

    final List<Widget> iconWidgets = [];

    for (int i = 0; i < positions.length; i++) {
      final pos = positions[i];
      final icon = icons[i % icons.length];
      final random = Random(i);
      final size = baseSize + random.nextInt(8); // Tamaños variados
      //final opacity = 0.15 + random.nextDouble() * 0.25;

      iconWidgets.add(Positioned(
        left: centerX + pos.dx,
        top: centerY + pos.dy,
        child: Icon(
          icon,
          size: size,
          color: Color.fromRGBO(253, 251, 253, 0.6), 
        ),
      ));
    }

    return iconWidgets;
  }
}
