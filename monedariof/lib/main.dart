import 'package:flutter/material.dart';
import 'views/splash_screen.dart'; //  Importa la pantalla de inicio



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monedario',
      theme: ThemeData(
        //primarySwatch: Colors.deepPurple,
      primaryColor: const Color(0xFFBBA5E3),
          ),
      home: const SplashScreen(), // <-- aquí inicia
    );
  }
}
