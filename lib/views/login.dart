import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';

// ===============================
//           LoginView
// ===============================
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // ===============================
  //   Controllers & Variables
  // ===============================
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
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // ===============================
  //           UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final headerHeight = h * 0.35;

    return Scaffold(
      body: Stack(
        children: [
          // ----- Fondo Degradado -----
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF78A3EB), Color(0xFF78A3EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ----- Card blanco inferior -----
          Positioned(
            top: headerHeight - 45,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(44), topRight: Radius.circular(44)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    const Text('Iniciar sesión', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
                    const SizedBox(height: 24),
                    _buildInput(_emailCtrl, "Correo electrónico", Icons.email, false),
                    const SizedBox(height: 16),
                    _buildInput(_passCtrl, "Contraseña", Icons.lock, true,
                        showPassword: _showPassword,
                        togglePassword: () => setState(() => _showPassword = !_showPassword)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(color: Color(0xFF78A3EB))),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // ----- Botón Entrar -----
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _loading ? null : () async {
                          setState(() => _loading = true);
                          await _controller.loginUser(context);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: EdgeInsets.zero,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF78A3EB), Color(0xFF78A3EB)]),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            child: _loading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('Entrar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white)),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),
                    Row(children: const [
                      Expanded(child: Divider(thickness: 1.2)),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('O ingresa con')),
                      Expanded(child: Divider(thickness: 1.2)),
                    ]),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialBtn('assets/facebook.png', () {}),
                        const SizedBox(width: 14),
                        _buildSocialBtn('assets/google.png', () {}),
                        const SizedBox(width: 14),
                        _buildSocialBtn('assets/apple.png', () {}),
                      ],
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿No tienes cuenta?", style: TextStyle(fontSize: 15)),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                          child: const Text('Regístrate', style: TextStyle(color: Color(0xFF78A3EB), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ----- Encabezado con imagen y texto -----
          SizedBox(
            height: headerHeight + 85,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                //Positioned(
                  //bottom: 20,
                  //right: 16,
                  //child: SizedBox(
                    //width: w * 0.65,
                    //height: headerHeight * 0.80,
                    //child: Image.asset('assets/polita_login.png', fit: BoxFit.contain),
                  //),
                //),
                Positioned(
                  top: headerHeight * 0.22,
                  left: 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('¡Bienvenido!', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Inicia sesión para continuar.', style: TextStyle(color: Colors.white70, fontSize: 17)),
                    ],
                  ),
                ),
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

  // ===============================
  //     Widgets Auxiliares
  // ===============================
  Widget _buildInput(TextEditingController c, String hint, IconData icon, bool obscure,
      {bool showPassword = false, VoidCallback? togglePassword}) {
    return TextField(
      controller: c,
      obscureText: obscure && !showPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF78A3EB)),
        suffixIcon: obscure
            ? IconButton(
                icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off, color: const Color(0xFF78A3EB)),
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
