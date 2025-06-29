import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../controllers/auth_controller.dart';
import '../ui/theme.dart'; 

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey      = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authCtrl = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: lilacBackground,
      body: Column(
        children: [
          // ── Cabecera curva + Lottie ──
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: cardTop,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(60),
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 12, right: 16),
                    child: Lottie.asset(
                      'assets/animations/cat_typing.json',
                      width: 140,
                      repeat: true,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 24, left: 24),
                    child: Text(
                      'trusty.',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: gradientStart, fontSize: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Formulario ──
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Iniciar sesión',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 24),

                    // Email
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: outlineDisabled),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: gradientStart),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: TextStyle(color: Colors.grey[800]),
                      validator: (v) =>
                          v != null && v.contains('@') ? null : 'Email inválido',
                    ),

                    SizedBox(height: 12),

                    // Contraseña
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: outlineDisabled),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: gradientStart),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: TextStyle(color: Colors.grey[800]),
                      validator: (v) =>
                          v != null && v.length >= 6 ? null : 'Mínimo 6 caracteres',
                    ),

                    SizedBox(height: 24),

                    // Botón gradiente
                    ElevatedButton(
                      onPressed: authCtrl.loading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                authCtrl.login(
                                  _emailCtrl.text.trim(),
                                  _passwordCtrl.text,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [gradientStart, gradientEnd],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: authCtrl.loading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'Entrar',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Link a registro
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed('register'),
                      child: Text('¿No tienes cuenta? Regístrate'),
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
