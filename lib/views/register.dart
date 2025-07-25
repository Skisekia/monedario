// Agrega esto arriba de tu clase
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
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  String _selectedGender = 'Masculino';
  bool _showPassword = false;
  bool _showPassword2 = false;
  bool _loading = false;
  late RegisterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterController(
      emailCtrl: _emailCtrl,
      passCtrl: _passCtrl,
      pass2Ctrl: _pass2Ctrl,
      nameCtrl: _nameCtrl,
      phoneCtrl: _phoneCtrl,
      gender: _selectedGender,
      onSuccess: () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login'); // Ir al login despues registro exitoso
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
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final headerHeight = isTablet ? 280.0 : 230.0;
          final imageHeight = isTablet ? 200.0 : 160.0;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Fondo degradado
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF78A3EB), Color(0xFF78A3EB)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // Card blanco
              Positioned(
                top: headerHeight - 40,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(44), topRight: Radius.circular(44)),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4)),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.7,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/cata_register.png',
                            height: imageHeight,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Registro',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                        const SizedBox(height: 20),
                        _buildInput(_nameCtrl, "Nombre completo", Icons.person, false),
                        const SizedBox(height: 15),
                        _buildInput(_emailCtrl, "Correo electrónico", Icons.email, false),
                        const SizedBox(height: 15),
                        _buildInput(_phoneCtrl, "Número de teléfono", Icons.phone, false),
                        const SizedBox(height: 15),
                        _buildDropdownSexo(),
                        const SizedBox(height: 15),
                        _buildInput(_passCtrl, "Contraseña", Icons.lock, true,
                            showPassword: _showPassword,
                            togglePassword: () => setState(() => _showPassword = !_showPassword)),
                        const SizedBox(height: 15),
                        _buildInput(_pass2Ctrl, "Repite la contraseña", Icons.lock_outline, true,
                            showPassword: _showPassword2,
                            togglePassword: () => setState(() => _showPassword2 = !_showPassword2)),
                        const SizedBox(height: 25),
                        _buildRegisterButton(),
                        const SizedBox(height: 18),
                        Row(children: const [
                          Expanded(child: Divider(thickness: 1.2)),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('O regístrate con')),
                          Expanded(child: Divider(thickness: 1.2)),
                        ]),
                        const SizedBox(height: 12),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("¿Ya tienes cuenta?", style: TextStyle(fontSize: 15)),
                            TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                              child: const Text('Inicia sesión',
                                  style: TextStyle(
                                      color: Color(0xFF78A3EB), fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Título
              Positioned(
                top: 70,
                left: 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Crea tu cuenta',
                        style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Crea una cuenta para continuar.',
                        style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ],
                ),
              ),

              // Botón atrás
              Positioned(
                top: 14,
                left: 8,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                  onPressed: () => Navigator.pushReplacementNamed(context, '/welcome'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ======= Tus widgets auxiliares (sin cambios) ==========
  Widget _buildInput(TextEditingController c, String hint, IconData icon, bool obscure,
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
                icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF78A3EB)),
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

  Widget _buildDropdownSexo() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      style: const TextStyle(color: Color(0xFF1B1D28), fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF78A3EB)),
        filled: true,
        fillColor: const Color(0xFFF4F6FA),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
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
                await _controller.registerUser(context);
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF78A3EB),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
        ),
        child: _loading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Registrarme',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white)),
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
