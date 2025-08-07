import 'dart:async';
import 'package:flutter/material.dart';

// Color de fondo de la pantalla de inicio
const _lilac = Color(0xFFBBA5E3);
 // Pantalla de inicio que se muestra al abrir la aplicación
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Estado de la pantalla de inicio
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 3400), () {
      Navigator.of(context).pushReplacementNamed('/welcome');
    });
  }

// Construye la interfaz de usuario de la pantalla de inicio
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lilac,
      body: const Center(
        child: Text(
          'Monedario',
          style: TextStyle(fontSize: 64, color: Colors.white),
        ),
      ),
    );
  }
}
