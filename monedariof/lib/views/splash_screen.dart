import 'dart:async';
import 'package:flutter/material.dart';

/// Colores que utilizo
const _lilacBackground = Color(0xFFBBA5E3);

/// Pantalla inicial tipo Splash.
/// Muestra título y, tras 3.4s, va a '/welcome' y elimina '/splash'.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Espero 3.4 segundos y luego reemplazo la ruta
    Timer(const Duration(milliseconds: 3400), () {
      Navigator.of(context).pushReplacementNamed('/welcome');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lilacBackground,
      body: const Center(
        child: Text(
          'Monedario',
          style: TextStyle(
            fontSize: 64,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
