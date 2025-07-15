import 'dart:async';
import 'package:flutter/material.dart';

const _lilac = Color(0xFFBBA5E3);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 3400), () {
      Navigator.of(context).pushReplacementNamed('/welcome');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lilac,
      body: const Center(
        child: Text(
          'Monedario',
          style: TextStyle(fontSize: 64, color: Colors.white),
        ),
      ),
    );
  }
}
