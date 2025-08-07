import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

// Widget que representa un botón de opción en el modal
// Este widget se usa para mostrar diferentes acciones que el usuario puede realizar
class _OptionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  // Constructor del botón de opción
  // Recibe el ícono, color, etiqueta y acción a realizar al pulsar
  const _OptionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  // Botón de opción para el modal
  // Este widget representa un botón con un ícono, color y etiqueta
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

// Pantalla de marcador de posición para las acciones
// Esta pantalla se usa para mostrar un mensaje de que la vista está en construcción
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

// Esta pantalla es un marcador de posición para las acciones
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
// Navega a una pantalla de marcador de posición con el título dado
void _pushPlaceholder(BuildContext context, String title) {
  Navigator.of(context).pop();
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => _PlaceholderScreen(title: title)),
  );
}
// Muestra el modal de acciones de transacciones
void showTransactionActionsModal(BuildContext context, [TransactionModel? debtModel]) =>
    _showCentered(context, _transactionOptions(context, debtModel));
// Muestra el modal de acciones de balance
void showBalanceActionsModal(BuildContext context) =>
    _showCentered(context, _balanceOptions(context));
// Muestra el modal de acciones de amigos
void showFriendsActionsModal(BuildContext context) =>
    _showCentered(context, _friendsOptions(context));

// Genera las opciones para el modal de transacciones
List<List<_OptionButton>> _transactionOptions(BuildContext ctx, TransactionModel? debtModel) => [
      [
        // Botones para gastos, ingresos y transacciones
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
        // Botones para pagos, préstamos y deudas
         _OptionButton(
          icon: Icons.handshake_rounded,
          color: Colors.teal,
          label: 'Pago',
          onTap: () {
            Navigator.of(ctx).pop();
            Navigator.of(ctx).pushNamed('/add_payment');
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
            Navigator.of(ctx).pushNamed('/add_debt');
          },
        ),
      ],
    ];

// Genera las opciones para el modal de balance

List<List<_OptionButton>> _balanceOptions(BuildContext ctx) => [
      [
        // Botones para añadir ingresos, gastos y tarjetas
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
        // Botones para ver gráficas, fechas de pago y estadísticas
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

// Genera las opciones para el modal de amigos
List<List<_OptionButton>> _friendsOptions(BuildContext ctx) => [
      [
        // Botones para agregar amigo, ver grupos y préstamos/deudas
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
        // Botones para eliminar amigo, vincular amigo e invitar amigo
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

// Muestra un diálogo centrado con las opciones dadas
void _showCentered(BuildContext context, List<List<_OptionButton>> optionRows) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => _CenteredDialog(
      title: '¿Qué deseas hacer?',
      optionRows: optionRows,
    ),
  );
}

// Diálogo centrado que muestra las opciones de acción
// Este widget se usa para mostrar un diálogo con varias opciones de acción
class _CenteredDialog extends StatelessWidget {
  final String title;
  final List<List<_OptionButton>> optionRows;

// Constructor del diálogo centrado
  const _CenteredDialog({
    required this.title,
    required this.optionRows,
  });

// Construye el diálogo centrado con un título y filas de opciones
  @override
  Widget build(BuildContext context) {
    final double maxDialogWidth =
        MediaQuery.of(context).size.width > 480 ? 440 : double.infinity;

    // Retorna un diálogo con un diseño centrado y opciones
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
