import 'package:flutter/material.dart';

/// Pantalla de bienvenida.
/// Ofrece iniciar sesión o crear cuenta.
class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    // Medidas de pantalla para adaptarse (responsive)
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Asegura que el contenido no quede tras barras del sistema
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal:20, vertical: 80),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // ————————————————————————
                // Título "Monedario"
                // ————————————————————————
                Text(
                  'Monedario',
                  style: TextStyle(
                    fontSize: screenWidth * 0.10,      // 12% del ancho
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),  // 5% del alto

                // ————————————————————————
                // Imagen central
                // ————————————————————————
                // Ajustamos la imagen para que no desborde
                Image.asset(
                  'assets/iconhome.png',
                  width:  screenWidth * 0.8,  // 80% del ancho
                  height: screenHeight * 0.3, // 30% del alto
                  fit: BoxFit.contain,
                ),

                SizedBox(height: screenHeight * 0.03),

                // ————————————————————————
                // Texto 
                // ————————————————————————
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(fontSize: screenWidth * 0.06, color: Colors.black),
                    children: [
                      const TextSpan(text: 'Organiza lo que '),
                      TextSpan(
                        text: 'tienes',
                        style: TextStyle(
                          color: const Color(0xFF673AB7), // morado
                          fontSize: screenWidth * 0.08,
                          fontFamily: 'Cursive',
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.015),

                // ————————————————————————
                // Texto 
                // ————————————————————————
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(fontSize: screenWidth * 0.06, color: Colors.black),
                    children: [
                      const TextSpan(text: 'Logra lo que '),
                      TextSpan(
                        text: 'quieres',
                        style: TextStyle(
                          color: const Color(0xFF673AB7), // morado
                          fontSize: screenWidth * 0.08,
                          fontFamily: 'Cursive',
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),

                // ————————————————————————
                // Botón: Iniciar sesión
                // ————————————————————————
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFA79BF5), // GradientStart
                            Color(0xFF9D80EC), // GradientEnd
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: const Center(
                        child: Text(
                          'Iniciar sesión',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.015),

                // ————————————————————————
                // Botón: Crear cuenta
                // ————————————————————————
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/register');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF512DA8)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Crear cuenta',
                      style: TextStyle(color: Color(0xFF512DA8)),
                    ),
                  ),
                ),

                // Un pequeño margen inferior para que no toque el borde
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
