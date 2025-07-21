import 'package:flutter/material.dart';
import '../controllers/register_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // Controladores de campos de texto
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();

  // Estados para mostrar/ocultar contraseñas y loading
  bool _showPassword = false;
  bool _showPassword2 = false;
  bool _loading = false;

  late RegisterController _controller;

  @override
  void initState() {
    super.initState();

    // Instancia del controlador
    _controller = RegisterController(
      emailCtrl: _emailCtrl,
      passCtrl: _passCtrl,
      pass2Ctrl: _pass2Ctrl,
      nameCtrl: _nameCtrl,
      onSuccess: () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      },
      onError: (msg) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        setState(() => _loading = false);
      },
    );
  }

  @override
  void dispose() {
    // Liberar recursos
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final headerHeight = h * 0.35;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo degradado rosa-azul
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFBC2EB), Color(0xFF78A3EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Card blanco inferior
          Positioned(
            top: headerHeight - 45,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(44),
                  topRight: Radius.circular(44),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4)),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),

                    // Título
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Registro',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Campos de entrada
                    _buildInput(_nameCtrl, "Nombre completo", Icons.person, false),
                    const SizedBox(height: 15),
                    _buildInput(_emailCtrl, "Correo electrónico", Icons.email, false),
                    const SizedBox(height: 15),
                    _buildInput(
                      _passCtrl, "Contraseña", Icons.lock, true,
                      showPassword: _showPassword,
                      togglePassword: () => setState(() => _showPassword = !_showPassword),
                    ),
                    const SizedBox(height: 15),
                    _buildInput(
                      _pass2Ctrl, "Repite la contraseña", Icons.lock_outline, true,
                      showPassword: _showPassword2,
                      togglePassword: () => setState(() => _showPassword2 = !_showPassword2),
                    ),

                    const SizedBox(height: 25),

                    // Botón de registro
                                    SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            setState(() => _loading = true);
                            await _controller.registerUser(context);
                          },
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
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Registrarme',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                      ),
                    ),
                  ),
                ),

                    const SizedBox(height: 18),

                    // Divider con texto
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
                        _buildSocialBtn('assets/google.png', () {
                          setState(() => _loading = true);
                          _controller.signInWithGoogle();
                        }),
                        const SizedBox(width: 14),
                        _buildSocialBtn('assets/apple.png', () {}),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Enlace para iniciar sesión
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿Ya tienes cuenta?", style: TextStyle(fontSize: 15)),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                          child: const Text(
                            'Inicia sesión',
                            style: TextStyle(
                              color: Color(0xFF78A3EB),
                              fontWeight: FontWeight.bold,
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

          // Header con imagen y texto
          SizedBox(
            height: headerHeight + 103,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Imagen decorativa a la derecha
                Positioned(
                  bottom: 20,
                  right: 16,
                  child: SizedBox(
                    width: w * 0.65,
                    height: headerHeight * 0.80,
                    child: Image.asset(
                      'assets/cata_register.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Texto superior izquierdo
                Positioned(
                  top: headerHeight * 0.22,
                  left: 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Crear cuenta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
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

                // Botón de retroceso
                Positioned(
                  top: 14,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                    onPressed: () => Navigator.pushReplacementNamed(context, '/welcome'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Campo de texto reutilizable
  Widget _buildInput(
    TextEditingController c,
    String hint,
    IconData icon,
    bool obscure, {
    bool showPassword = false,
    VoidCallback? togglePassword,
  }) {
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

  /// Botón social redondo con sombra
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
