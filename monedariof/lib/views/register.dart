import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Register> {
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB39DDB),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          // Detectar orientación
          final isLandscape = constraints.maxWidth > constraints.maxHeight;

          //Si esta en horizontal


          if (isLandscape) {
            // En horizontal: el card y header llenan todo el ancho
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(constraints.maxWidth, constraints.maxHeight),
                  _buildCard(constraints.maxWidth, constraints.maxHeight),
                ],
              ),
            );
          } else {

          // Dimensiones base de diseño (portrait)
          const baseWidth  = 800.0;
          const baseHeight = 840.0;

          // Sólo en landscape escalamos para que todo quepa
          final scale = isLandscape
              ? min(constraints.maxWidth  / baseWidth,
                    constraints.maxHeight / baseHeight)
              : 1.0;

          return Center(
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: baseWidth,
                height: baseHeight,
                child: _buildContent(baseWidth, baseHeight),
              ),
            ),
          );
        }
        }
        ),
      ),
    );
  }

  /// Construye el Stack con HEADER y CARD basado en un ancho y alto fijos
  Widget _buildContent(double width, double height) {
    final headerHeight = height * 0.35;
    final cardHeight   = height * 0.65;
    final sidePadding  = width * 0.06;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ─── CABECERA CURVA ───
        ClipRRect(
          borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(headerHeight * 0.15)),
          child: Container(
            height: headerHeight,
            color: const Color(0xFFB39DDB),
            padding: EdgeInsets.symmetric(
              horizontal: sidePadding,
              vertical: headerHeight * 0.15,
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Monedario',
                    style: TextStyle(
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF512DA8),
                    ),
                  ),
                ),
                Positioned(
                  top: -headerHeight * 0.3,
                  right: -width * 0.0,
                  width: width * 0.6,
                  height: headerHeight * 1.5,
                  child: Lottie.asset(
                    'assets/cat_typing.json',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ─── CARD BLANCO ───
        Positioned(
          top: headerHeight - 50,
          left: 0,
          right: 0,
          child: Container(
            height: cardHeight + 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(sidePadding, 32, sidePadding, 2),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crea una cuenta',
                      style: TextStyle(
                        fontSize: width * 0.065,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(controller: _nameCtrl,  hint: 'Tu nombre',      icon: Icons.person, width: width),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _emailCtrl, hint: 'ejemplo@gmail.com', icon: Icons.email, keyboardType: TextInputType.emailAddress, width: width),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _passCtrl,  hint: '********',       icon: Icons.lock,    obscure: true, width: width),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, '/welcome'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF9575CD), Color(0xFFD1C4E9)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Crear cuenta',
                              style: TextStyle(color: Colors.white, fontSize: width * 0.045),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('Continuar con'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Image.asset('assets/google.png', width: 24, height: 24),
                            label: const Text('Google'),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Image.asset('assets/facebook.png', width: 24, height: 24),
                            label: const Text('Facebook'),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    required double width,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF555555)),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}
