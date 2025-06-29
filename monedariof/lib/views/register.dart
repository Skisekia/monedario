import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Register> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fija orientación solo vertical
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Restaurar todas las orientaciones
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // header ocupa espacio suficiente para texto y animación
    final headerHeight = h * 0.3;

    return Scaffold(
      backgroundColor: const Color(0xFFB39DDB),
      body: SafeArea(
        child: Column(
          children: [
            // Header con back y texto intercambiados y animación
            SizedBox(
              height: headerHeight,
              child: Stack(
                children: [
                  // Fondo morado
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFB39DDB),
                  ),
                  // Lottie animación
                  Positioned(
                    right: w * 0.04,
                    bottom: 0,
                    child: SizedBox(
                      width: w * 0.7,
                      height: headerHeight * 0.7,
                      child: Lottie.asset(
                        'assets/cat_typing.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Back button donde estaba texto
                  Positioned(
                    left: w * 0.02,
                    top: h * 0.02,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed('/welcome'),
                    ),
                  ),
                  // Texto donde estaba boton
                  Positioned(
                    top: h * 0.075,
                    left: 15,
                    child: Text(
                      'Monedario',
                      style: TextStyle(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF512DA8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Espacio mínimo antes del card
            SizedBox(height: h * 0.01),
            // Card principal
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.06,
                  vertical: h * 0.025,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Crea una cuenta',
                      style: TextStyle(
                        fontSize: w * 0.055,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    _buildField(_nameCtrl, 'Tu nombre', Icons.person, w),
                    SizedBox(height: h * 0.015),
                    _buildField(
                        _emailCtrl, 'ejemplo@gmail.com', Icons.email, w,
                        keyboardType: TextInputType.emailAddress),
                    SizedBox(height: h * 0.015),
                    _buildField(_passCtrl, 'Contraseña', Icons.lock, w,
                        obscure: true),
                    SizedBox(height: h * 0.015),
                    _buildField(
                        _pass2Ctrl, 'Repite contraseña', Icons.lock, w,
                        obscure: true),
                    SizedBox(height: h * 0.03),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed('/welcome'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF9575CD),
                                Color(0xFFD1C4E9),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Crear cuenta',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.040,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.025),
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
                    SizedBox(height: h * 0.015),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Image.asset('assets/google.png',
                                width: 24, height: 24),
                            label: const Text('Google'),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        SizedBox(width: w * 0.04),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Image.asset('assets/facebook.png',
                                width: 24, height: 24),
                            label: const Text('Facebook'),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController c,
    String hint,
    IconData icon,
    double w, {
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
  }) {
    return TextField(
      controller: c,
      keyboardType: keyboardType,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF555555)),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
