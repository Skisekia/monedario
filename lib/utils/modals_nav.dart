import 'package:flutter/material.dart';

/// BOTÓN REUTILIZABLE
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
        Text(label,
            style:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

/// PANTALLA DE PLACEHOLDER  
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

/// Función auxiliar para empujar un placeholder.
/// `Navigator.of(context).pushNamed('/gasto');`
void _pushPlaceholder(BuildContext context, String title) {
  Navigator.of(context).pop(); // cierra el diálogo
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => _PlaceholderScreen(title: title)),
  );
}

/// MODALES PÚBLICOS
//esta función se usa en el Dashboard para mostrar las opciones de deudas
void showTransactionActionsModal(BuildContext context) =>
    _showCentered(context, _transactionOptions(context));

/// esta función se usa en el Dashboard para mostrar las opciones de balance
void showBalanceActionsModal(BuildContext context) =>
    _showCentered(context, _balanceOptions(context));
//esta función se usa en el Dashboard para mostrar las opciones de amigos
void showFriendsActionsModal(BuildContext context) =>
    _showCentered(context, _friendsOptions(context));


// IMPLEMENTACIÓN COMÚN
void _showCentered(
    BuildContext context, List<List<_OptionButton>> optionRows) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) =>
        _CenteredDialog(title: '¿Qué deseas hacer?', optionRows: optionRows),
  );
}


/// OPCIONES POR MODAL  cada botón usa _pushPlaceholder
/// cada función devuelve una lista de listas de botones (_OptionButton)
List<List<_OptionButton>> _transactionOptions(BuildContext context) => [
      [
        _OptionButton(
          icon: Icons.add_shopping_cart_rounded,
          color: Colors.blueAccent,
          label: 'Gasto',
          onTap: () => _pushPlaceholder(context, 'Gasto'),
        ),
        _OptionButton(
          icon: Icons.attach_money_rounded,
          color: Colors.green,
          label: 'Ingreso',
          onTap: () => _pushPlaceholder(context, 'Ingreso'),
        ),
        _OptionButton(
          icon: Icons.account_balance_wallet_rounded,
          color: Colors.deepPurple,
          label: 'Transacción',
          onTap: () => _pushPlaceholder(context, 'Transacción'),
        ),
      ],
      [
        _OptionButton(
          icon: Icons.payments_rounded,
          color: Colors.teal,
          label: 'Pago',
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/payment_view');
          },
        ),
        _OptionButton(
          icon: Icons.handshake_rounded,
          color: Colors.orange,
          label: 'Préstamo',
          onTap: () => _pushPlaceholder(context, 'Préstamo'),
        ),
        _OptionButton(
          icon: Icons.account_balance_rounded,
          color: Colors.pink,
          label: 'Deuda',
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/debt_view');
          },
        ),
      ],
    ];

List<List<_OptionButton>> _balanceOptions(BuildContext context) => [
      [
        _OptionButton(
          icon: Icons.attach_money_rounded,
          color: Colors.green,
          label: 'Añadir ingreso',
          onTap: () => _pushPlaceholder(context, 'Añadir ingreso'),
        ),
        _OptionButton(
          icon: Icons.add_shopping_cart_rounded,
          color: Colors.blueAccent,
          label: 'Añadir gasto',
          onTap: () => _pushPlaceholder(context, 'Añadir gasto'),
        ),
        _OptionButton(
          icon: Icons.credit_card_rounded,
          color: Colors.deepPurple,
          label: 'Añadir tarjeta',
          onTap: () => _pushPlaceholder(context, 'Añadir tarjeta'),
        ),
      ],
      [
        _OptionButton(
          icon: Icons.analytics_rounded,
          color: Colors.teal,
          label: 'Ver gráficas',
          onTap: () => _pushPlaceholder(context, 'Ver gráficas'),
        ),
        _OptionButton(
          icon: Icons.calendar_month_rounded,
          color: Colors.orange,
          label: 'Fechas de pago',
          onTap: () => _pushPlaceholder(context, 'Fechas de pago'),
        ),
        _OptionButton(
          icon: Icons.pie_chart_rounded,
          color: Colors.pink,
          label: 'Estadísticas',
          onTap: () => _pushPlaceholder(context, 'Estadísticas'),
        ),
      ],
    ];

List<List<_OptionButton>> _friendsOptions(BuildContext context) => [
      [
        _OptionButton(
          icon: Icons.person_add_rounded,
          color: Colors.green,
          label: 'Agregar amigo',
          onTap: () => _pushPlaceholder(context, 'Agregar amigo'),
        ),
        _OptionButton(
          icon: Icons.group_rounded,
          color: Colors.blueAccent,
          label: 'Ver grupos',
          onTap: () => _pushPlaceholder(context, 'Ver grupos'),
        ),
        _OptionButton(
          icon: Icons.handshake_rounded,
          color: Colors.deepPurple,
          label: 'Préstamo/Deuda',
          onTap: () => _pushPlaceholder(context, 'Préstamo/Deuda'),
        ),
      ],
      [
        _OptionButton(
          icon: Icons.delete_rounded,
          color: Colors.pink,
          label: 'Eliminar amigo',
          onTap: () => _pushPlaceholder(context, 'Eliminar amigo'),
        ),
        _OptionButton(
          icon: Icons.link_rounded,
          color: Colors.orange,
          label: 'Vincular amigo',
          onTap: () => _pushPlaceholder(context, 'Vincular amigo'),
        ),
        _OptionButton(
          icon: Icons.send_rounded,
          color: Colors.teal,
          label: 'Invitar amigo',
          onTap: () => _pushPlaceholder(context, 'Invitar amigo'),
        ),
      ],
    ];

/// DIÁLOGO CENTRADO

class _CenteredDialog extends StatelessWidget {
  final String title;
  final List<List<Widget>> optionRows;

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
              padding:
                  const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
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
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF250E2C),
                      ),
                    ),
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
