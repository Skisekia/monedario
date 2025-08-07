// estas son que se importan en el archivo main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'views/add_debt.dart';
import 'views/add_payment.dart';

// Controladores
import 'controllers/auth_controller.dart';
import 'controllers/transaction_controller.dart';
import 'controllers/debt_controller.dart';


// Tema
import 'ui/theme.dart';

// Controladores 
Future<void> main() async {
  // Inicializar Firebase y establecer la orientación de la pantalla
  // Asegurarse de que los widgets de Flutter estén inicializados antes de usar Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

// Establecer la orientación de la pantalla a vertical
  // Esto es útil para aplicaciones que solo deben funcionar en modo vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Ejecutar la aplicación con MultiProvider para manejar el estado
  // MultiProvider permite inyectar múltiples proveedores en el árbol de widgets
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

// Clase principal de la aplicación
// Esta clase es el punto de entrada de la aplicación 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Método build que construye la interfaz de usuario de la aplicación
  // Utiliza MaterialApp para definir la estructura y el tema de la aplicación
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
      // Definir las rutas de la aplicación
      // Las rutas permiten navegar entre diferentes vistas de la aplicación
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
        '/add_debt'          : (_) => const AddDebtView(),
        '/add_payment'       : (_) => const AddPaymentView(),
        
        
      },
     
    );
  }
}
