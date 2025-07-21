import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 600;

            return Column(
              children: [
                SizedBox(height: h * 0.04),
                // Fondo sutil detrás de la imagen
                Container(
                  width: isTablet ? w * 0.6 : w * 0.8,
                  height: isTablet ? h * 0.45 : h * 0.35,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6FF), // color pastel suave
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/welcome_cats.png',
                    fit: BoxFit.contain,
                    width: isTablet ? w * 0.5 : w * 0.6,
                  ),
                ),

                SizedBox(height: h * 0.04),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: isTablet ? 28 : 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: const [
                        TextSpan(text: 'Bienvenido a '),
                        TextSpan(
                          text: 'Monedario',
                          style: TextStyle(color: Color(0xFF78A3EB)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'Administra tus finanzas, controla tus deudas y lleva el control desde una sola app.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 14,
                      fontFamily: 'Poppins',
                      color: Colors.black54,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.15),
                  child: SizedBox(
                    width: double.infinity,
                    height: isTablet ? 60 : 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF78A3EB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: Text(
                        'Comenzar',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/dashboard'),
                  child: const Text(
                    'Omitir',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black45,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
