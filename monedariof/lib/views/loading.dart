import 'dart:async';
import 'package:flutter/material.dart';

/// Pantalla de carga genérica:
/// delay de 500 ms y luego navega a [nextRoute].
class Loading extends StatefulWidget {
  final String nextRoute;
  const Loading({super.key, required this.nextRoute});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    // Espero 0.5 segundos y reemplazo la ruta
    Timer(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushReplacementNamed(widget.nextRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBBA5E3),
      body: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 4,
        ),
      ),
    );
  }
}
