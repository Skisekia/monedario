import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  bool _showPassword = false;
  bool _showPassword2 = false;
  bool _loading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _loading = true);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw Exception('Cancelado por usuario');
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      _showError('Ocurrió un error al iniciar sesión con Google');
    }
    setState(() => _loading = false);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final headerHeight = h * 0.32;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FF),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // HEADER animado
                SizedBox(
                  height: headerHeight,
                  child: Stack(
                    children: [
                      Container(
                        height: headerHeight,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFBC2EB),
                              Color(0xFF78A3EB),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(headerHeight * 0.10),
                            bottomRight: Radius.circular(headerHeight * 0.10),
                          ),
                        ),
                      ),
                      // Animación
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          width: w * 0.5,
                          height: headerHeight * 0.77,
                          child: Lottie.asset(
                            'assets/cat_box.json',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      // Botón atrás
                      Positioned(
                        top: 10,
                        left: 8,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                        ),
                      ),
                      // Texto de bienvenida
                      Positioned(
                        top: headerHeight * 0.20,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Crear cuenta',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Regístrate gratis y comienza hoy.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // TARJETA REGISTRO
                Container(
                  width: w * 0.99,
                  margin: const EdgeInsets.only(top: 2, bottom: 8),
                  padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Registro',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildInput(_nameCtrl, "Nombre completo", Icons.person, false),
                      const SizedBox(height: 15),
                      _buildInput(_emailCtrl, "Correo electrónico", Icons.email, false),
                      const SizedBox(height: 15),
                      _buildInput(_passCtrl, "Contraseña", Icons.lock, true,
                          showPassword: _showPassword,
                          togglePassword: () => setState(() => _showPassword = !_showPassword)),
                      const SizedBox(height: 15),
                      _buildInput(_pass2Ctrl, "Repite la contraseña", Icons.lock_outline, true,
                          showPassword: _showPassword2,
                          togglePassword: () => setState(() => _showPassword2 = !_showPassword2)),
                      const SizedBox(height: 25),

                      // Botón Registrar
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _loading ? null : () {}, // Aquí tu lógica de registro
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFBC2EB), Color(0xFF78A3EB)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              child: _loading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      'Registrarme',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Divider y social login
                      Row(children: const [
                        Expanded(child: Divider(thickness: 1.2)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('O regístrate con'),
                        ),
                        Expanded(child: Divider(thickness: 1.2)),
                      ]),
                      const SizedBox(height: 12),

                      // Botones sociales
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialBtn('assets/facebook.png', () {}),
                          const SizedBox(width: 14),
                          _buildSocialBtn('assets/google.png', _signInWithGoogle),
                          const SizedBox(width: 14),
                          _buildSocialBtn('assets/apple.png', () {}),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Navegación a login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("¿Ya tienes cuenta?",
                              style: TextStyle(fontSize: 15)),
                          TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                            child: const Text(
                              'Inicia sesión',
                              style: TextStyle(
                                  color: Color(0xFF78A3EB),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController c, String hint, IconData icon,
      bool obscure,
      {bool showPassword = false, VoidCallback? togglePassword}) {
    return TextField(
      controller: c,
      obscureText: obscure && !showPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF78A3EB)),
        suffixIcon: obscure
            ? IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF78A3EB),
                ),
                onPressed: togglePassword,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF4F6FA),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSocialBtn(String asset, VoidCallback onTap) {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: IconButton(
        icon: Image.asset(asset, width: 28, height: 28),
        onPressed: onTap,
      ),
    );
  }
}
