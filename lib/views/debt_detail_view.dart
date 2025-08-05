// 📄 lib/views/debt_detail_view.dart
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class DebtDetailView extends StatelessWidget {
  final TransactionModel debt;
  const DebtDetailView({super.key, required this.debt});

  @override
  Widget build(BuildContext context) {
    final remaining = debt.amount - debt.paid;
    return Scaffold(
      appBar: AppBar(title: Text('Detalle — ${debt.description}')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Monto total', '\$${debt.amount.toStringAsFixed(2)}'),
            _row('Pagado', '\$${debt.paid.toStringAsFixed(2)}'),
            _row('Restante', '\$${remaining.toStringAsFixed(2)}',
                valueColor: remaining == 0 ? Colors.green : null),
            const Divider(height: 32),
            const Text('Historial de pagos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            const Text('En construcción…'),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: valueColor)),
          ],
        ),
      );
}
