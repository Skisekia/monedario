import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';  
import 'firebase_options.dart';     
import 'package:provider/provider.dart';

// Rutas
import 'views/splash_screen.dart';
import 'views/welcome.dart';
import 'views/register.dart';
import 'views/login.dart';
//import 'views/loading.dart';
import 'views/dashboard.dart';
import 'views/settings_view.dart';

// Controlador
import 'controllers/auth_controller.dart';

// Tema
import 'ui/theme.dart';


void main() async {
  // Asegura que Flutter esté inicializado antes de tocar SystemChrome
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Bloquear solo modo retrato (arriba y abajo)
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
        // Usamos el color lila definido en theme.dart
        primaryColor: lilacBackground,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),

      initialRoute: '/welcome',
      routes: {
        '/splash':           (ctx) => const SplashScreen(),
        '/welcome':          (ctx) => const WelcomeView(),
        '/login':            (ctx) => const LoginView(),
        '/register':         (ctx) => const RegisterView(),
        '/dashboard': (ctx) => const Dashboard(),
        '/settings_view': (ctx) => const SettingsView(),
      },
    );
  }
}
