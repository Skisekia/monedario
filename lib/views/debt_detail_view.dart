import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';
//import '../models/enums.dart';

class DebtDetailView extends StatelessWidget {
  final TransactionModel debt;
  const DebtDetailView({super.key, required this.debt});

  @override
  Widget build(BuildContext context) {
    final remaining = debt.amount - debt.paid;
    final df        = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(title: Text('Detalle — ${debt.concept}')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _row('Concepto'       , debt.concept),
            _row('Acreedor'       , debt.owner),
            _row('Monto total'    , '\$${debt.amount.toStringAsFixed(2)}'),
            _row('Pagado'         , '\$${debt.paid.toStringAsFixed(2)}'),
            _row('Restante'       , '\$${remaining.toStringAsFixed(2)}',
                valueColor: remaining == 0 ? Colors.green : null),
            _row('Vencimiento'    , df.format(debt.dueDate)),
            _row('Frecuencia'     , _freqLabel(debt.frequency)),
            _row('Nº de pagos'    , debt.numPayments.toString()),
            _row('Tipo cuenta'    , debt.accountType.name),
            _row('Creado'         , df.format(debt.createdAt)),
            const SizedBox(height: 28),
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

  /* traducción bonita */
  String _freqLabel(PaymentFreq f) => switch (f) {
        PaymentFreq.mensual   => 'Mensual',
        PaymentFreq.quincenal => 'Quincenal',
        PaymentFreq.semanal   => 'Semanal',
      };
}
