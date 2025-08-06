// 📄 lib/utils/modals_nav.dart
import 'package:flutter/material.dart';

/*───────────────────────────────────────────────────────────────*/
/*                          BOTÓN OPCIÓN                         */
/*───────────────────────────────────────────────────────────────*/
class _OptionButton extends StatelessWidget {
  final IconData    icon;
  final Color       color;
  final String      label;
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
        Text(label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

/*───────────────────────────────────────────────────────────────*/
/*                         PLACEHOLDER                           */
/*───────────────────────────────────────────────────────────────*/
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Text(
            'Vista "$title"\nen construcción',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      );
}

void _pushPlaceholder(BuildContext context, String title) {
  Navigator.of(context).pop(); // cierra el diálogo
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => _PlaceholderScreen(title: title)),
  );
}

/*───────────────────────────────────────────────────────────────*/
/*                    MODALES PÚBLICOS                           */
/*───────────────────────────────────────────────────────────────*/
void showTransactionActionsModal(BuildContext context) =>
    _showCentered(context, _transactionOptions(context));

void showBalanceActionsModal(BuildContext context) =>
    _showCentered(context, _balanceOptions(context));

void showFriendsActionsModal(BuildContext context) =>
    _showCentered(context, _friendsOptions(context));

/*───────────────────────────────────────────────────────────────*/
/*                     LISTAS DE OPCIONES                        */
/*───────────────────────────────────────────────────────────────*/
List<List<_OptionButton>> _transactionOptions(BuildContext ctx) => [
      [
        _OptionButton(
          icon: Icons.add_shopping_cart_rounded,
          color: Colors.blueAccent,
          label: 'Gasto',
          onTap: () => _pushPlaceholder(ctx, 'Gasto'),
        ),
        _OptionButton(
          icon: Icons.attach_money_rounded,
          color: Colors.green,
          label: 'Ingreso',
          onTap: () => _pushPlaceholder(ctx, 'Ingreso'),
        ),
        _OptionButton(
          icon: Icons.account_balance_wallet_rounded,
          color: Colors.deepPurple,
          label: 'Transacción',
          onTap: () => _pushPlaceholder(ctx, 'Transacción'),
        ),
      ],
      [
        _OptionButton(
          icon: Icons.payments_rounded,
          color: Colors.teal,
          label: 'Pagos',
          onTap: () {
            Navigator.of(ctx).pop();
            Navigator.of(ctx).pushNamed('/add_payment'); // ← lista de pagos
          },
        ),
        _OptionButton(
          icon: Icons.handshake_rounded,
          color: Colors.orange,
          label: 'Préstamo',
          onTap: () => _pushPlaceholder(ctx, 'Préstamo'),
        ),
        _OptionButton(
          icon: Icons.account_balance_rounded,
          color: Colors.pink,
          label: 'Deudas',
          onTap: () {
            Navigator.of(ctx).pop();
            Navigator.of(ctx).pushNamed('/add_debt');   // ← lista de deudas
          },
        ),
      ],
    ];

/*—— balance ——*/
List<List<_OptionButton>> _balanceOptions(BuildContext ctx) => [
      [
        _OptionButton(
          icon: Icons.attach_money_rounded,
          color: Colors.green,
          label: 'Añadir ingreso',
          onTap: () => _pushPlaceholder(ctx, 'Añadir ingreso'),
        ),
        _OptionButton(
          icon: Icons.add_shopping_cart_rounded,
          color: Colors.blueAccent,
          label: 'Añadir gasto',
          onTap: () => _pushPlaceholder(ctx, 'Añadir gasto'),
        ),
        _OptionButton(
          icon: Icons.credit_card_rounded,
          color: Colors.deepPurple,
          label: 'Añadir tarjeta',
          onTap: () => _pushPlaceholder(ctx, 'Añadir tarjeta'),
        ),
      ],
      [
        _OptionButton(
          icon: Icons.analytics_rounded,
          color: Colors.teal,
          label: 'Ver gráficas',
          onTap: () => _pushPlaceholder(ctx, 'Ver gráficas'),
        ),
        _OptionButton(
          icon: Icons.calendar_month_rounded,
          color: Colors.orange,
          label: 'Fechas de pago',
          onTap: () => _pushPlaceholder(ctx, 'Fechas de pago'),
        ),
        _OptionButton(
          icon: Icons.pie_chart_rounded,
          color: Colors.pink,
          label: 'Estadísticas',
          onTap: () => _pushPlaceholder(ctx, 'Estadísticas'),
        ),
      ],
    ];

/*—— amigos ——*/
List<List<_OptionButton>> _friendsOptions(BuildContext ctx) => [
      [
        _OptionButton(
          icon: Icons.person_add_rounded,
          color: Colors.green,
          label: 'Agregar amigo',
          onTap: () => _pushPlaceholder(ctx, 'Agregar amigo'),
        ),
        _OptionButton(
          icon: Icons.group_rounded,
          color: Colors.blueAccent,
          label: 'Ver grupos',
          onTap: () => _pushPlaceholder(ctx, 'Ver grupos'),
        ),
        _OptionButton(
          icon: Icons.handshake_rounded,
          color: Colors.deepPurple,
          label: 'Préstamo/Deuda',
          onTap: () => _pushPlaceholder(ctx, 'Préstamo/Deuda'),
        ),
      ],
      [
        _OptionButton(
          icon: Icons.delete_rounded,
          color: Colors.pink,
          label: 'Eliminar amigo',
          onTap: () => _pushPlaceholder(ctx, 'Eliminar amigo'),
        ),
        _OptionButton(
          icon: Icons.link_rounded,
          color: Colors.orange,
          label: 'Vincular amigo',
          onTap: () => _pushPlaceholder(ctx, 'Vincular amigo'),
        ),
        _OptionButton(
          icon: Icons.send_rounded,
          color: Colors.teal,
          label: 'Invitar amigo',
          onTap: () => _pushPlaceholder(ctx, 'Invitar amigo'),
        ),
      ],
    ];

/*───────────────────────────────────────────────────────────────*/
/*                      DIÁLOGO CENTRADO                         */
/*───────────────────────────────────────────────────────────────*/
void _showCentered(
    BuildContext context, List<List<_OptionButton>> optionRows) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => _CenteredDialog(
      title: '¿Qué deseas hacer?',
      optionRows: optionRows,
    ),
  );
}

class _CenteredDialog extends StatelessWidget {
  final String                    title;
  final List<List<_OptionButton>> optionRows;

  const _CenteredDialog({
    required this.title,
    required this.optionRows,
  });

  @override
  Widget build(BuildContext context) {
    final double maxDialogWidth =
        MediaQuery.of(context).size.width > 480 ? 440 : double.infinity;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxDialogWidth),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 42,
                        height: 6,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Text(title,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF250E2C),
                        )),
                    const SizedBox(height: 26),
                    ...optionRows.map(
                      (row) => Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: row,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
