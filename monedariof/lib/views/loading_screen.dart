import 'dart:async';
import 'package:flutter/material.dart';

/// Esta pantalla se muestra brevemente mientras se carga una acción.
/// Después de medio segundo (500ms), navega automáticamente a la siguiente ruta.
///
/// Se usa para animaciones como "loadingLogin" o "loadingRegister".
class LoadingScreen extends StatefulWidget {
  final String nextRoute;

  const LoadingScreen({super.key, required this.nextRoute});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    // Espera 500ms y navega a la ruta siguiente
    Timer(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushReplacementNamed(widget.nextRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBBA5E3), // fondo lila como en splash
      body: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 5,
        ),
      ),
    );
  }
}
