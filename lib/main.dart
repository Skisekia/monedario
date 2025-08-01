import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

// Rutas y vistas
import 'views/splash_screen.dart';
import 'views/welcome.dart';

// Vistas con alias para evitar conflictos
import 'package:monedario/views/login.dart' as login;
import 'package:monedario/views/register.dart' as register;
import 'package:monedario/views/forgot_password_view.dart' as forgot_password;

import 'views/dashboard.dart';
import 'views/settings_view.dart';

// Controlador
import 'controllers/auth_controller.dart';

// Tema
import 'ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Bloquear orientación en retrato
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
        primaryColor: lilacBackground,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      initialRoute: '/welcome',
      routes: {
        '/splash': (ctx) => const SplashScreen(),
        '/welcome': (ctx) => const WelcomeView(),
        // Rutas con alias para evitar conflictos
        '/login': (ctx) => const login.LoginView(),
        '/register': (ctx) => const register.RegisterView(),
        '/forgot_password': (ctx) => const forgot_password.ForgotPasswordView(),
        '/dashboard': (ctx) => const Dashboard(),
        '/settings_view': (ctx) => const SettingsView(),
      },
    );
  }
}
