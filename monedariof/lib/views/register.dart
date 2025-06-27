import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Pantalla de registro refinada para parecerse al mockup:
/// - Fondo lila claro
/// - Cabecera con curva superior y animación Lottie centrada
/// - Card blanco con bordes redondeados empezando a mitad de la pantalla
/// - Título “Crea una cuenta” dentro del card, alineado a la izquierda
/// - Campos con placeholders y bordes suaves (12dp radio)
/// - Botón “Crear cuenta” con gradiente horizontal y texto blanco
/// - Separador “Or sign up with” centrado
/// - Botones sociales de Google y Facebook con iconos y texto
class Register extends StatefulWidget {
  const Register({super.key});

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
    // Colores base
    //const Color bgLilac       = Color(0xFFEDE7F6);
    const Color lilac         = Color(0xFFB39DDB);
    const Color gradientStart = Color(0xFF9575CD);
    const Color gradientEnd   = Color(0xFFD1C4E9);
    //const Color darkGray      = Color(0xFF555555);

    return Scaffold(
      backgroundColor: lilac,
      body: Stack(
        children: [
          // ─── CABECERA CURVO ───
          ClipRRect(
  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
  child: Container(
    height: MediaQuery.of(context).size.height * 0.4,
    color: lilac,
    padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 150),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Texto “Monedario” alineado a la izquierda
        const Text(
          'Monedario',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Color(0xFF512DA8),
          ),
        ),

        // Empuja la animación hacia la derecha
        const Spacer(),

        // Animación Lottie en la esquina superior derecha
        // 2. La animación superpuesta, con offset negativo
        Positioned(
          top: -60,             // 60px sobre el borde superior del Card
          right:  -20,          // opcional, para ajustarla un poco a la derecha
          child: SizedBox(
            width: 400,
            height: 400,
            child: Lottie.asset('assets/cat_typing.json'),
          ),
        ),
      ],
    ),
  ),
),

          // ─── CARD BLANCO ───
          Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            widthFactor: 1,             
              child: Stack(
              clipBehavior: Clip.none,
              children: [
              // 1. El Card blanco
              Container(
              height: MediaQuery.of(context).size.height * 0.72,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),

              
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      const Text(
                        'Crea una cuenta',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Campo Nombre
                      _buildTextField(
                        controller: _nameCtrl,
                        hint: 'Tu nombre',
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 16),

                      // Campo Email
                      _buildTextField(
                        controller: _emailCtrl,
                        hint: 'ejemplo@gmail.com',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      // Campo Contraseña
                      _buildTextField(
                        controller: _passCtrl,
                        hint: '********',
                        icon: Icons.lock,
                        obscure: true,
                      ),
                      const SizedBox(height: 32),

                      // Botón Gradiente
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
                                colors: [gradientStart, gradientEnd],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Crear cuenta',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Separador
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

                      // Botones sociales
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: Image.asset('assets/google.png', width: 24, height: 24),
                              label: const Text('Google'),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
            ],
          ),
          ),
        ),
        ],
      ),
    );
  }

  /// Construye un TextField con placeholder y borde redondeado.
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
