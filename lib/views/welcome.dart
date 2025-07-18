import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFBC2EB), // Rosa pastel (arriba)
              Color(0xFF78A3EB), // Azul-violeta pastel (abajo)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: h * 0.055),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Column(
                  children: [
                    Text(
                      'Bienvenido a\nMonedario',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: w * 0.11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF432C69),
                        letterSpacing: 1.1,
                        height: 1.12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '¡Tu espacio para organizar y cuidar tus finanzas! Controla tus gastos, visualiza tu avance y alcanza tus metas.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: w * 0.048,
                        color: Colors.black54,
                        height: 1.35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.035),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: h * 0.03),
                    child: Lottie.asset(
                      'assets/panel.json',
                      width: w * 0.67,
                      height: h * 0.34,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: h * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.13),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF6C4EE4),
                          Color(0xFF78A3EB),
                          Color(0xFFFBC2EB),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.18),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: const Text(
                        '¡Comenzar!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'App versión 1.0.1',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
