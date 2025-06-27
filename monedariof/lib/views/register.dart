import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Pantalla de registro.
/// Incluye animación Lottie, campos y botones sociales.
class Register extends StatefulWidget {
  const Register({super.key});
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const darkGray = Color(0xFF555555);

    return Scaffold(
      backgroundColor: const Color(0xFFBBA5E3),
      body: Stack(
        children: [
          // Cabecera lila
          Container(height: 300, color: const Color(0xFFBBA5E3)),
          // Animación Lottie de gatito
          Positioned(
            top: 12,
            right: 16,
            child: SizedBox(
              width: 300,
              height: 300,
              child: Lottie.asset('assets/cat_typing.json'),
            ),
          ),
          // Texto “Monedario” arriba
          const Positioned(
            top: 50,
            left: 24,
            child: Text(
              'Monedario',
              style: TextStyle(fontSize: 22, color: Color(0xFF512DA8)),
            ),
          ),
          // Card de formulario
          Positioned.fill(
            top: 250,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'Crea una cuenta',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Campo Nombre
                    TextField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Campo Email
                    TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Campo Contraseña
                    TextField(
                      controller: _passCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),

                    const SizedBox(height: 20),
                    // Botón Crear cuenta
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Al crear cuenta regreso a welcome
                          Navigator.of(context)
                              .pushReplacementNamed('/welcome');
                        },
                        child: const Text('Crear cuenta'),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Separador “Continuar con”
                    Row(
                      children: const [
                        Expanded(child: Divider(color: darkGray)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('Continuar con',
                              style: TextStyle(color: darkGray)),
                        ),
                        Expanded(child: Divider(color: darkGray)),
                      ],
                    ),

                    const SizedBox(height: 16),
                    // Botones Google / Facebook
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Image.asset('assets/google.png', width: 18),
                            label: const Text('Google'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon:
                                Image.asset('assets/facebook.png', width: 18),
                            label: const Text('Facebook'),
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
    );
  }
}
