import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // 👈 Import para usar Lottie

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final isTablet = w > 600;

    // 🎨 Gradiente basado en la paleta enviada
    const gradientColors = [
      Color(0xFF250E2C), // Morado oscuro
      Color(0xFF837AB6), // Lavanda
      Color(0xFFF6A5C0), // Rosa suave
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🎬 Animación Lottie en lugar de imagen
                    SizedBox(
                      height: isTablet ? h * 0.48 : h * 0.40,
                      child: Lottie.asset(
                        'assets/finance_boy.json',
                        fit: BoxFit.contain,
                        width: isTablet ? w * 0.65 : w * 0.8,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Texto Bienvenida
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
                        color: Colors.pink.shade100,
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
                          foregroundColor: const Color(0xFF250E2C),
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
                          side: const BorderSide(color: Colors.white, width: 2),
                          foregroundColor: Colors.white,
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
      ),
    );
  }
}
