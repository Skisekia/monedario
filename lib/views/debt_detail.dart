import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/transaction_model.dart';
import '../models/payment_model.dart';
import '../models/enums.dart';
import '../controllers/debt_controller.dart';

class DebtDetail extends StatelessWidget {
  final TransactionModel debt;
  const DebtDetail({super.key, required this.debt});

  @override
  Widget build(BuildContext context) {
    final remaining = debt.amount - debt.paid;
    final df = DateFormat('dd/MM/yyyy');
    final allPayments = context.watch<DebtController>().allPayments;
    // Filtra pagos de esta deuda
    final debtPayments = allPayments.where((p) => p.debtId == debt.id).toList();

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
            debtPayments.isEmpty
                ? const Text('Aún no hay pagos registrados para esta deuda.',
                    style: TextStyle(color: Color(0xFF837AB6)))
                : Column(
                    children: debtPayments
                        .map((p) => Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: const Icon(Icons.payments_outlined, color: Color(0xFF837AB6)),
                                title: Text('\$${p.amount.toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(df.format(p.date)),
                                trailing: p.comprobanteUrl != null && p.comprobanteUrl!.isNotEmpty
                                    ? const Icon(Icons.receipt, color: Colors.green)
                                    : null,
                                onTap: () => _showPaymentDetail(context, p),
                              ),
                            ))
                        .toList(),
                  ),
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

  String _freqLabel(PaymentFreq f) => switch (f) {
        PaymentFreq.mensual   => 'Mensual',
        PaymentFreq.quincenal => 'Quincenal',
        PaymentFreq.semanal   => 'Semanal',
        PaymentFreq.anual     => 'Anual',
        PaymentFreq.diaria    => 'Diaria',
      };

  void _showPaymentDetail(BuildContext context, PaymentModel payment) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Detalle del pago'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Monto: \$${payment.amount.toStringAsFixed(2)}'),
            if (payment.comprobanteUrl != null && payment.comprobanteUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: payment.comprobanteUrl!.startsWith('file://')
                    ? Image.file(
                        File(payment.comprobanteUrl!.substring(7)), height: 120)
                    : Image.network(payment.comprobanteUrl!, height: 120),
              ),
            Text('Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(payment.date)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          )
        ],
      ),
    );
  }
}
