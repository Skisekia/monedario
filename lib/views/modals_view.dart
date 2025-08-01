import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'notifications_view.dart';

void showForgotPasswordModal(BuildContext context) {
  final emailResetCtrl = TextEditingController();
  final authController = Provider.of<AuthController>(context, listen: false);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              child: Lottie.asset(
                'assets/girl_support.json',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Recuperar contraseña",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailResetCtrl,
              decoration: const InputDecoration(
                hintText: "Ingresa tu correo electrónico",
                prefixIcon: Icon(Icons.email, color: Color(0xFF837AB6)),
                filled: true,
                fillColor: Color(0xFFF4F6FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () async {
                final email = emailResetCtrl.text.trim();
                if (email.isEmpty) {
                  showErrorNotification(context, "Por favor ingresa tu correo");
                  return;
                }
                await authController.sendPasswordResetEmail(
                  email,
                  onSuccess: () {
                    Navigator.pop(context);
                    showSuccessNotification(context,
                        "Hemos enviado un enlace para restablecer tu contraseña.");
                  },
                  onError: (msg) {
                    Navigator.pop(context);
                    showErrorNotification(context, msg);
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ).copyWith(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
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
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 48,
                  child: const Text(
                    "Enviar enlace",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
