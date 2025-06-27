import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'welcome_screen.dart';

void main() {
  runApp(const MonedarioApp());
}

/// Punto de entrada de la app. Aquí defino las rutas y el tema general.
class MonedarioApp extends StatelessWidget {
  const MonedarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monedario',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash', // Pantalla inicial
      routes: {
        // Ruta hacia la pantalla de bienvenida
        '/splash': (context) => const SplashScreen(),

        // Paso el método de navegación hacia la pantalla de bienvenida
        '/welcome': (context) => WelcomeScreen(
              onNavigate: (route) =>
                  Navigator.of(context).pushReplacementNamed(route),
            ),

        // Estas son pantallas temporales (placeholders) para las animaciones de login/registro
        '/loadingLogin': (context) => _placeholder('Login...'),
        '/loadingRegister': (context) => _placeholder('Registro...'),
      },
    );
  }

  /// Placeholder temporal para animaciones de carga
  Widget _placeholder(String text) => Scaffold(
        body: Center(child: Text(text)),
      );
}
