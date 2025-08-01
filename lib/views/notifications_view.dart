import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showSuccessNotification(BuildContext context, String message) {
  _showNotification(context, message, true);
}

void showErrorNotification(BuildContext context, String message) {
  _showNotification(context, message, false);
}

void _showNotification(BuildContext context, String message, bool success) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 150,
            child: Lottie.asset(
              success ? 'assets/send.json' : 'assets/girl_support.json',
              repeat: false,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            success ? "¡Éxito!" : "Error",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: success ? Colors.green[700] : Colors.red[700],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Aceptar"),
        ),
      ],
    ),
  );
}
