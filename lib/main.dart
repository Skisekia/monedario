// 📄 lib/main.dart
// ──────────────────────────────────────────────────────────────
// Paquetes
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:monedario/views/add_debt.dart';
import 'package:monedario/views/add_payment.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

// Vistas
import 'views/splash_screen.dart';
import 'views/welcome.dart';
import 'views/login.dart'       as login;
import 'views/register.dart'    as register;
import 'views/forgot_password_view.dart' as forgot_password;
import 'views/edit_profile_view.dart';
import 'views/dashboard.dart';
import 'views/settings_view.dart';
import 'views/transaction_form_view.dart';

// Controladores
import 'controllers/auth_controller.dart';
import 'controllers/transaction_controller.dart';
import 'controllers/debt_controller.dart';

// Tema
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthController>(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => TransactionController()),
        ChangeNotifierProvider(create: (_) => DebtController()),
      ],
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

      // ------------- Rutas -------------
      // *Ya no apuntamos a los formularios modales antiguos*
      initialRoute: '/welcome',
      routes: {
        '/splash'            : (_) => const SplashScreen(),
        '/welcome'           : (_) => const WelcomeView(),
        '/login'             : (_) => const login.LoginView(),
        '/register'          : (_) => const register.RegisterView(),
        '/forgot_password'   : (_) => const forgot_password.ForgotPasswordView(),
        '/dashboard'         : (_) => const Dashboard(),
        '/settings_view'     : (_) => const SettingsView(),
        '/edit_profile_view' : (_) => const EditProfileView(),
        '/transaction_form_view' : (_) => const TransactionFormView(),

        // ← pantallas lista + FAB
        '/add_debt'    : (_) => const AddDebtView(),
        '/add_payments' : (_) => const AddPaymentView(),
      },
    );
  }
}
