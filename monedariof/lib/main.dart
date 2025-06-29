import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Rutas
import 'views/splash_screen.dart';
import 'views/welcome.dart';
import 'views/register.dart';
import 'views/login.dart';
import 'views/loading.dart';

// Controlador
import 'controllers/auth_controller.dart';

// Tema
import 'ui/theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monedario',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Usamos el color lila definido en theme.dart
        primaryColor: lilacBackground,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),

      initialRoute: '/splash',
      routes: {
        '/splash':           (ctx) => const SplashScreen(),
        '/welcome':          (ctx) => const Welcome(),
        '/login':            (ctx) => const LoginView(),
        '/register':         (ctx) => const Register(),
        '/loading_login':    (ctx) => const Loading(nextRoute: '/welcome'),
        '/loading_register': (ctx) => const Loading(nextRoute: '/register'),
      },
    );
  }
}
