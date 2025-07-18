import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFBC2EB),
              Color(0xFF78A3EB),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: h * 0.045),
              Text(
                'Bienvenido a Monedario',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: w * 0.072,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: h * 0.045),
              Lottie.asset(
                'assets/panel.json',
                width: w * 0.90,
                height: h * 0.50,
                fit: BoxFit.contain,
              ),
              SizedBox(height: h * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.14),
                child: Text(
                  'Organiza tus finanzas, visualiza tu progreso y alcanza tus metas.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: w * 0.041,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.35,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: h * 0.06),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.15),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFBC2EB),
                            Color(0xFF78A3EB),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Comenzar',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.7,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'App versión 1.0.1',
                style: TextStyle(
                  fontSize: 13.5,
                  color: Colors.white70,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
