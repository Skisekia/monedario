import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/debt_controller.dart';
import '../models/enums.dart';
import '../models/transaction_model.dart';

/*───────────────────────────────────────────────────────────────*/
/*                  1.  DEBT FORM (NUEVO)                        */
/*───────────────────────────────────────────────────────────────*/
class DebtForm extends StatefulWidget {
  final void Function(TransactionModel debt) onSubmit;
  const DebtForm({super.key, required this.onSubmit});

  @override
  State<DebtForm> createState() => _DebtFormState();
}

class _DebtFormState extends State<DebtForm> {
  final _conceptCtrl = TextEditingController();
  final _amountCtrl  = TextEditingController();

  @override
  void dispose() {
    _conceptCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Añadir deuda', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),

          TextFormField(
            controller: _conceptCtrl,
            decoration: const InputDecoration(labelText: 'Concepto / descripción'),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _amountCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Monto total (\$)'),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Guardar'),
              onPressed: () {
                final amount = double.tryParse(_amountCtrl.text) ?? 0;
                if (amount <= 0 || _conceptCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Datos inválidos')),
                  );
                  return;
                }

                final debt = TransactionModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  amount: amount,
                  description: _conceptCtrl.text.trim(),
                  type: TransactionType.debt,
                  accountType: AccountType.credit,
                  date: DateTime.now(),
                );

                widget.onSubmit(debt);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/*───────────────────────────────────────────────────────────────*/
/*                  2.  PAYMENT FORM (EXISTENTE)                 */
/*───────────────────────────────────────────────────────────────*/
class PaymentForm extends StatefulWidget {
  final void Function(double amount, String debtId) onSubmit;
  const PaymentForm({super.key, required this.onSubmit});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _amountCtrl = TextEditingController();
  String? _selectedDebtId;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final debts = context.watch<DebtController>().activeDebts;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Registrar pago', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),

          DropdownButtonFormField<String>(
            value: _selectedDebtId,
            decoration: const InputDecoration(labelText: 'Selecciona la deuda'),
            items: debts
                .map((d) => DropdownMenuItem(
                      value: d.id,
                      child: Text(
                          '${d.description ?? 'Sin descripción'} (\$${(d.amount - d.paid).toStringAsFixed(2)})'),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _selectedDebtId = v),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _amountCtrl,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: 'Monto del pago (\$)'),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Guardar'),
              onPressed: () {
                final amount = double.tryParse(_amountCtrl.text) ?? 0;
                if (_selectedDebtId == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Completa los datos')),
                  );
                  return;
                }
                widget.onSubmit(amount, _selectedDebtId!);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
