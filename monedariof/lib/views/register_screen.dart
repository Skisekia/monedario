import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';



/// Pantalla de registro donde el usuario puede crear una cuenta.
/// Incluye animación Lottie, campos personalizados y botones sociales.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para los campos de texto
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    // Limpia los controladores cuando se destruye la vista
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const lilacColor = Color(0xFFBBA5E3);
    const darkGray = Color(0xFF555555);
    const gradientStart = Color(0xFFA79BF5);
    const gradientEnd = Color(0xFF9D80EC);

    return Scaffold(
      backgroundColor: lilacColor,
      body: Stack(
        children: [
          // Animación de gatito en la cabecera
          Positioned(
            top: 12,
            right: 16,
            child: SizedBox(
              width: 300,
              height: 300,
              child: Lottie.asset(
                'assets/cat_typing.json', // asegúrate de tener el .json aquí
                repeat: true,
              ),
            ),
          ),

          // Texto "Monedario"
          const Positioned(
            top: 50,
            left: 24,
            child: Text(
              "Monedario",
              style: TextStyle(fontSize: 22, color: Color(0xFF512DA8)),
            ),
          ),

          // Tarjeta de registro
          Positioned.fill(
            top: 250,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
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
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Crea una cuenta",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Campo nombre
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Nombre",
                        prefixIcon: const Icon(Icons.person, color: darkGray),
                        border: const OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Campo correo
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Correo electrónico",
                        prefixIcon: const Icon(Icons.email, color: darkGray),
                        border: const OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Campo contraseña
                    TextField(
                      controller: passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        prefixIcon: const Icon(Icons.lock, color: darkGray),
                        border: const OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Botón registrar con gradiente
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/welcome');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [gradientStart, gradientEnd],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: const Center(
                            child: Text("Crear cuenta", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Divider con texto
                    Row(
                      children: const [
                        Expanded(child: Divider(color: darkGray)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text("Continuar con", style: TextStyle(color: darkGray)),
                        ),
                        Expanded(child: Divider(color: darkGray)),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Botones Google y Facebook
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Image.asset('assets/google.png', width: 18),
                            label: const Text("Google", style: TextStyle(color: darkGray)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Image.asset('assets/facebook.png', width: 18),
                            label: const Text("Facebook", style: TextStyle(color: darkGray)),
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
