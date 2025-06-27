import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final void Function(String route) onNavigate;
  const WelcomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenido a Monedario'),
            ElevatedButton(
              onPressed: () => onNavigate('/register'),
              child: const Text('Crear cuenta'),
            )
          ],
        ),
      ),
    );
  }
}
