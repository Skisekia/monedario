import 'package:flutter/material.dart';

/// Pantalla de bienvenida.
/// Ofrece iniciar sesión o crear cuenta.
class Welcome extends StatelessWidget {
  const Welcome({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Fondo blanco semitransparente
      backgroundColor: const Color(0xF0FFFFFF),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título Monedario
            const Text(
              'Monedario',
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Imagen central
            Image.asset(
              'assets/iconhome.png', // tu icono en assets
              width: 300,
              height: 300,
            ),

            const SizedBox(height: 20),

            // Texto “Organiza lo que tienes”
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 30, color: Colors.black),
                children: [
                  TextSpan(text: 'Organiza lo que '),
                  TextSpan(
                    text: 'tienes',
                    style: TextStyle(
                      color: Color(0xFF673AB7), // morado
                      fontSize: 40,
                      fontFamily: 'Cursive',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Texto “Logra lo que quieres”
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 30, color: Colors.black),
                children: [
                  TextSpan(text: 'Logra lo que '),
                  TextSpan(
                    text: 'quieres',
                    style: TextStyle(
                      color: Color(0xFF673AB7), // morado
                      fontSize: 40,
                      fontFamily: 'Cursive',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Botón Iniciar sesión
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Navega a animación de login
                  Navigator.of(context).pushReplacementNamed('/loading_login');
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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

            const SizedBox(height: 10),

            // Botón Crear cuenta
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  // Navega a animación de registro
                  Navigator.of(context)
                      .pushReplacementNamed('/loading_register');
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF512DA8)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Crear cuenta',
                  style: TextStyle(color: Color(0xFF512DA8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
