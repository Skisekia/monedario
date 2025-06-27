import 'package:flutter/material.dart';
import 'views/splash_screen.dart';
import 'views/welcome.dart';
import 'views/register.dart';
import 'views/loading.dart';

void main() => runApp(const MyApp());

/// Punto de entrada de la app Monedario.
/// Defino tema general y todas las rutas necesarias.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monedario',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Color lila principal
        primaryColor: const Color(0xFFBBA5E3),
        scaffoldBackgroundColor: Colors.white,
      ),

      // Defino rutas iniciales
      // Arranca en la pantalla splash
      initialRoute: '/splash',

      // Mapa de rutas con sus widgets correspondientes
      routes: {
        '/splash':          (ctx) => const SplashScreen(),
        '/welcome':         (ctx) => const Welcome(),
        '/register':        (ctx) => const Register(),
        // Reuso Loading para login y registro
        '/loading_login':    (ctx) => const Loading(nextRoute: '/welcome'),
        '/loading_register': (ctx) => const Loading(nextRoute: '/register'),
      },
    );
  }
}
