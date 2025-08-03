import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../controllers/login_controller.dart';
import '../utils/modals_view.dart'; // Aquí estará tu función showForgotPasswordModal

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _showPassword = false;
  bool _loading = false;
  late LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController(
      emailCtrl: _emailCtrl,
      passCtrl: _passCtrl,
      onSuccess: () {
        if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
      },
      onError: (msg) {
        setState(() => _loading = false);
      },
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final cardTopMargin = isTablet ? 200.0 : screenHeight * 0.18;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            currentFocus.unfocus();
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              // ==== Fondo gradiente ====
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF250E2C),
                      Color(0xFF837AB6),
                      Color(0xFFF6A5C0),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    // ==== Texto bienvenida ====
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 42),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '¡Bienvenido!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Inicia sesión para continuar.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ==== Card + Animación ====
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // ==== Card blanco ====
                          Container(
                            margin: EdgeInsets.only(top: cardTopMargin),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(44),
                                topRight: Radius.circular(44),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, -4),
                                ),
                              ],
                            ),
                            child: ListView(
                              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                              children: [
                                const SizedBox(height: 40),
                                const Text(
                                  'Iniciar sesión',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                _buildInput(_emailCtrl, "Correo electrónico",
                                    Icons.email, false),
                                const SizedBox(height: 16),
                                _buildInput(_passCtrl, "Contraseña", Icons.lock,
                                    true,
                                    showPassword: _showPassword,
                                    togglePassword: () => setState(() =>
                                        _showPassword = !_showPassword)),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () =>
                                        showForgotPasswordModal(context),
                                    child: const Text(
                                      '¿Olvidaste tu contraseña?',
                                      style:
                                          TextStyle(color: Color(0xFF837AB6)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // ==== Botón entrar ====
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _loading
                                        ? null
                                        : () async {
                                            setState(() => _loading = true);
                                            await _controller.loginUser(context);
                                          },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                    ).copyWith(
                                      backgroundColor:
                                          WidgetStateProperty.all(
                                              Colors.transparent),
                                    ),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF250E2C),
                                            Color(0xFF837AB6),
                                            Color(0xFFF6A5C0),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: _loading
                                            ? const CircularProgressIndicator(
                                                color: Colors.white)
                                            : const Text(
                                                'Entrar',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  color: Colors.white,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Row(children: const [
                                  Expanded(child: Divider(thickness: 1.2)),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Text('O ingresa con'),
                                  ),
                                  Expanded(child: Divider(thickness: 1.2)),
                                ]),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildSocialBtn('assets/facebook.png', () {
                                      _controller.signInWithFacebook();
                                    }),
                                    const SizedBox(width: 14),
                                    _buildSocialBtn('assets/google.png', () {
                                      _controller.signInWithGoogle();
                                    }),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("¿No tienes cuenta?",
                                        style: TextStyle(fontSize: 15)),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pushReplacementNamed(
                                              context, '/register'),
                                      child: const Text(
                                        'Regístrate',
                                        style: TextStyle(
                                          color: Color(0xFF837AB6),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // ==== Animación ====
                          Positioned(
                            top: isTablet ? -40 : -40,
                            left: 0,
                            right: 0,
                            child: IgnorePointer(
                              ignoring: true,
                              child: Center(
                                child: SizedBox(
                                  height: isTablet ? 300 : 250,
                                  child: Lottie.asset(
                                    'assets/girl_computer.json',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ==== Botón regresar ====
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 26),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/welcome'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==== Métodos auxiliares ====
  Widget _buildInput(TextEditingController c, String hint, IconData icon,
      bool obscure,
      {bool showPassword = false, VoidCallback? togglePassword}) {
    return TextField(
      controller: c,
      obscureText: obscure && !showPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF837AB6)),
        suffixIcon: obscure
            ? IconButton(
                icon: Icon(
                    showPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: const Color(0xFF837AB6)),
                onPressed: togglePassword,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF4F6FA),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
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
