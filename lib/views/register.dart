import 'package:flutter/material.dart';
import '../controllers/register_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _selectedGender = 'Masculino';
  bool _showPassword = false;
  bool _loading = false;
  late RegisterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterController(
      nameCtrl: _nameCtrl,
      emailCtrl: _emailCtrl,
      passCtrl: _passCtrl,
      gender: _selectedGender,
      // Callback para éxito
      onSuccess: () {
        if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
      },
      onError: (msg) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
        setState(() => _loading = false);
      },
    );
  }

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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              final isTablet = constraints.maxWidth > 600;
              final imageWidth = isTablet ? 220.0 : constraints.maxWidth * 0.5;
              final baseOverlap = imageWidth / 2;
              final initialTop = constraints.maxHeight < 650
                  ? baseOverlap * 0.5
                  : baseOverlap + 20;
              final cardTop = initialTop - 20;

              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF78A3EB), Color(0xFF78A3EB)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Crea tu cuenta',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('Crea una cuenta para continuar.',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Card blanco con scroll solo si hace falta
                          Container(
                            margin: EdgeInsets.only(top: cardTop),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 20),
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
                                    offset: Offset(0, -4)),
                              ],
                            ),
                            child: ListView(
                              physics: const ClampingScrollPhysics(),
                              children: [
                                const SizedBox(height: 40),
                                const Text('Registro',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30)),
                                const SizedBox(height: 24),
                                _buildInput(
                                    _nameCtrl, "Nombre completo", Icons.person, false),
                                const SizedBox(height: 15),
                                _buildInput(
                                    _emailCtrl, "Correo electrónico", Icons.email, false),
                                const SizedBox(height: 15),
                                _buildDropdownSexo(),
                                const SizedBox(height: 15),
                                _buildInput(
                                  _passCtrl,
                                  "Contraseña",
                                  Icons.lock,
                                  true,
                                  showPassword: _showPassword,
                                  togglePassword: () =>
                                      setState(() => _showPassword = !_showPassword),
                                ),
                                const SizedBox(height: 25),
                                _buildRegisterButton(),
                                const SizedBox(height: 18),
                                Row(children: const [
                                  Expanded(child: Divider(thickness: 1.2)),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text('O regístrate con')),
                                  Expanded(child: Divider(thickness: 1.2)),
                                ]),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildSocialBtn('assets/facebook.png',
                                        () => _controller.signInWithFacebook()),
                                    const SizedBox(width: 14),
                                    _buildSocialBtn('assets/google.png', () {
                                      setState(() => _loading = true);
                                      _controller.signInWithGoogle();
                                    }),
                                    const SizedBox(width: 14),
                                    _buildSocialBtn('assets/apple.png',
                                        () => _controller.signInWithApple()),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("¿Ya tienes cuenta?",
                                        style: TextStyle(fontSize: 15)),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pushReplacementNamed(
                                              context, '/login'),
                                      child: const Text('Inicia sesión',
                                          style: TextStyle(
                                              color: Color(0xFF78A3EB),
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Imagen sobrepuesta
                          //Positioned(
                           // top: -48,
                            //right: isTablet ? 60 : 30,
                            //child: SizedBox(
                              //width: imageWidth,
                              //child: Image.asset(
                                //'assets/cat_login.png',
                               // fit: BoxFit.contain,
                             // ),
                           // ),
                          //),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            // Back button
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/welcome'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
      TextEditingController c, String hint, IconData icon, bool obscure,
      {bool showPassword = false, VoidCallback? togglePassword}) {
    return TextField(
      controller: c,
      obscureText: obscure && !showPassword,
      style: const TextStyle(color: Color(0xFF1B1D28)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF1B1D28)),
        prefixIcon: Icon(icon, color: const Color(0xFF78A3EB)),
        suffixIcon: obscure
            ? IconButton(
                icon: Icon(
                  showPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: const Color(0xFF78A3EB),
                ),
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

  Widget _buildDropdownSexo() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      style: const TextStyle(color: Color(0xFF1B1D28), fontSize: 16),
      decoration: InputDecoration(
        prefixIcon:
            const Icon(Icons.person_outline, color: Color(0xFF78A3EB)),
        filled: true,
        fillColor: const Color(0xFFF4F6FA),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
        DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
        DropdownMenuItem(value: 'Otro', child: Text('Otro')),
      ],
      onChanged: (value) {
        if (value != null) setState(() => _selectedGender = value);
      },
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _loading
            ? null
            : () async {
                setState(() => _loading = true);
                _controller.gender = _selectedGender;
                await _controller.registerUser(context);
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF78A3EB),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
        ),
        child: _loading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Registrarme',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white)),
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
