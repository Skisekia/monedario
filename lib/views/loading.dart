import 'dart:async';
import 'package:flutter/material.dart';

/// Pantalla de carga genérica:
/// delay de 500 ms y luego navega a [nextRoute].
/// He quitado la barra de progreso para que solo se vea el fondo lila.
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
    // Espero 0.5 segundos y luego reemplazo la ruta
    Timer(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushReplacementNamed(widget.nextRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Solo fondo lila, sin indicador de progreso
      backgroundColor: Color(0xFFBBA5E3),
      body: SizedBox.shrink(),
    );
  }
}
