import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

// ========== TU MODAL ORIGINAL CENTRAL (ModalsView) ==========
class ModalsView extends StatelessWidget {
  const ModalsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "¿Qué deseas agregar?",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF250E2C),
            ),
          ),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _OptionButton(
                icon: Icons.add_shopping_cart_rounded,
                color: Colors.blueAccent,
                label: 'Gasto',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _OptionButton(
                icon: Icons.attach_money_rounded,
                color: Colors.green,
                label: 'Ingreso',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _OptionButton(
                icon: Icons.account_balance_wallet_rounded,
                color: Colors.deepPurple,
                label: 'Transacción',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _OptionButton(
                icon: Icons.payments_rounded,
                color: Colors.teal,
                label: 'Pago',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _OptionButton(
                icon: Icons.handshake_rounded,
                color: Colors.orange,
                label: 'Préstamo',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _OptionButton(
                icon: Icons.account_balance_rounded,
                color: Colors.pink,
                label: 'Deuda',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ========== BOTÓN REUTILIZABLE ==========
class _OptionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _OptionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: color.withAlpha(38),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(icon, color: color, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// ========== MODALES NUEVOS PARA BALANCE Y AMIGOS ==========

/// MODAL DE ACCIONES DE BALANCE
void showBalanceActionsModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Opciones de Balance",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF250E2C),
            ),
          ),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _OptionButton(
                icon: Icons.attach_money_rounded,
                color: Colors.green,
                label: 'Añadir ingreso',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _OptionButton(
                icon: Icons.add_shopping_cart_rounded,
                color: Colors.blueAccent,
                label: 'Añadir gasto',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _OptionButton(
                icon: Icons.credit_card_rounded,
                color: Colors.deepPurple,
                label: 'Añadir tarjeta',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _OptionButton(
                icon: Icons.analytics_rounded,
                color: Colors.teal,
                label: 'Ver gráficas',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _OptionButton(
                icon: Icons.calendar_month_rounded,
                color: Colors.orange,
                label: 'Fechas de pago',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _OptionButton(
                icon: Icons.pie_chart_rounded,
                color: Colors.pink,
                label: 'Estadísticas',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}

/// MODAL DE ACCIONES DE AMIGOS
void showFriendsActionsModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Opciones de Amigos",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF250E2C),
            ),
          ),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _OptionButton(
                icon: Icons.person_add_rounded,
                color: Colors.green,
                label: 'Agregar amigo',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _OptionButton(
                icon: Icons.group_rounded,
                color: Colors.blueAccent,
                label: 'Ver grupos',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _OptionButton(
                icon: Icons.handshake_rounded,
                color: Colors.deepPurple,
                label: 'Préstamos/Deudas',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _OptionButton(
                icon: Icons.delete_rounded,
                color: Colors.pink,
                label: 'Eliminar amigo',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _OptionButton(
                icon: Icons.link_rounded,
                color: Colors.orange,
                label: 'Vincular amigo',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _OptionButton(
                icon: Icons.send_rounded,
                color: Colors.teal,
                label: 'Invitar amigo',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}

/// MODAL DE ACCIONES DE TRANSACCIONES (por si quieres llamarlo por función)
void showTransactionActionsModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ModalsView(),
  );
}

// ========== TUS MODALES ORIGINALES (NO SE MODIFICAN) ==========

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

void showErrorNotification(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Text(message, style: const TextStyle(color: Colors.white)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showSuccessNotification(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green,
      content: Text(message, style: const TextStyle(color: Colors.white)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

