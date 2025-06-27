import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Espera 3 segundos antes de navegar a MainActivity
    
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/main_activity.dart');
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/cat_typing.json', // Asegúrate que exista este archivo
          width: 200,
          repeat: true,
        ),
      ),
    );
  }
}
