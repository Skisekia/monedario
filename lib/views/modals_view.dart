import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'notifications_view.dart';

/// Modal para recuperar contraseña
void showForgotPasswordModal(BuildContext context) {
  final emailResetCtrl = TextEditingController();
  final authController = Provider.of<AuthController>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_reset, size: 80, color: Colors.purple),
            const SizedBox(height: 10),
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
                    showSuccessNotification(
                        context, "Hemos enviado un enlace para restablecer tu contraseña.");
                  },
                  onError: (msg) {
                    Navigator.pop(context);
                    showErrorNotification(context, msg);
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ).copyWith(
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
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

/// Modal centrado para seleccionar moneda
void showCurrencyModal(BuildContext context, Function(String) onSelect) {
  final currencies = [
    {"code": "MXN", "name": "Peso Mexicano", "icon": Icons.attach_money},
    {"code": "USD", "name": "Dólar", "icon": Icons.attach_money},
    {"code": "EUR", "name": "Euro", "icon": Icons.euro},
    {"code": "NIO", "name": "Córdoba Nicaragüense", "icon": Icons.attach_money}
  ];

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Selecciona tu moneda",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: currencies.map((currency) {
              return ListTile(
                leading: Icon(currency["icon"] as IconData, color: Colors.purple),
                title: Text("${currency["code"]} - ${currency["name"]}"),
                onTap: () {
                  onSelect(currency["code"] as String);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}

/// Modal centrado para seleccionar idioma
void showLanguageModal(BuildContext context, Function(String) onSelect) {
  final languages = [
    {"name": "Español", "flag": "🇪🇸"},
    {"name": "Inglés", "flag": "🇺🇸"},
    {"name": "Francés", "flag": "🇫🇷"},
    {"name": "Portugués", "flag": "🇵🇹"},
    {"name": "Alemán", "flag": "🇩🇪"}
  ];

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Selecciona tu idioma",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: languages.map((lang) {
              return ListTile(
                leading: Text(lang["flag"] as String, style: const TextStyle(fontSize: 24)),
                title: Text(lang["name"] as String),
                onTap: () {
                  onSelect(lang["name"] as String);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}

/// Modal para introducir código de invitación
void showAddFriendCodeModal(BuildContext context) {
  final TextEditingController codeController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Agregar amigo"),
        content: TextField(
          controller: codeController,
          decoration: const InputDecoration(
            labelText: "Código de invitación",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Lógica de vinculación aquí
            },
            child: const Text("Vincular"),
          ),
        ],
      );
    },
  );
}

/// Modal para mostrar código de invitación generado
void showInviteFriendCodeModal(BuildContext context) {
  const generatedCode = "ABCD1234";

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Invitar amigo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Comparte este código con tu amigo:"),
            const SizedBox(height: 10),
            SelectableText(
              generatedCode,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar"),
          ),
        ],
      );
    },
  );
}

/// Modal inferior para elegir entre agregar o invitar amigo
void showFriendLinkModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.group_add, color: Colors.purple, size: 40),
            const SizedBox(height: 10),
            const Text(
              "Vincular con otros usuarios",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.green),
              title: const Text("Agregar amigo con código"),
              subtitle: const Text("Introduce un código para vincularte"),
              onTap: () {
                Navigator.pop(context);
                showAddFriendCodeModal(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.send, color: Colors.blue),
              title: const Text("Invitar amigo"),
              subtitle: const Text("Genera un código para compartir"),
              onTap: () {
                Navigator.pop(context);
                showInviteFriendCodeModal(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
