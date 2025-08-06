import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/debt_controller.dart';

/*───────────────────────────────────────────────────────────────*/
/*                     LISTA (placeholder)                       */
/*───────────────────────────────────────────────────────────────*/
class AddPaymentView extends StatelessWidget {
  const AddPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagos')),
      body: const _PaymentsPlaceholder(),
      floatingActionButton: const _GradientFab(),
    );
  }
}

/*───────────────────────────────────────────────────────────────*/
class _GradientFab extends StatelessWidget {
  const _GradientFab();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF7F30FF), Color(0xFF9F7BFF)],
        ),
      ),
      child: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: () => _showPaymentForm(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

/*───────────────────────────────────────────────────────────────*/
void _showPaymentForm(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _PaymentForm(),
  );
}

class _PaymentForm extends StatefulWidget {
  const _PaymentForm();

  @override
  State<_PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<_PaymentForm> {
  final _formKey    = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  String? _selectedDebtId;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final debts   = context.read<DebtController>().activeDebts;
    final padding = MediaQuery.of(context).viewInsets;

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, padding.bottom + 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Registrar pago',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),

              /* deuda a la que se abona */
              DropdownButtonFormField<String>(
                value      : _selectedDebtId,
                decoration : const InputDecoration(labelText: 'Selecciona la deuda'),
                items      : debts.map((d) => DropdownMenuItem(
                  value: d.id,
                  child: Text(
                    '${d.concept} '
                    '(\$${(d.amount - d.paid).toStringAsFixed(2)})',
                  ),
                )).toList(),
                onChanged  : (v) => setState(() => _selectedDebtId = v),
                validator  : (v) => v == null ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),

              /* monto */
              TextFormField(
                controller : _amountCtrl,
                keyboardType: TextInputType.number,
                decoration : const InputDecoration(labelText: 'Monto del pago (\$)'),
                validator  : (v) =>
                    (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Inválido' : null,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon : const Icon(Icons.save),
                  label: const Text('Guardar'),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    final amount = double.parse(_amountCtrl.text);
                    context.read<DebtController>()
                           .registerPayment(_selectedDebtId!, amount);

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(
                        'Pago de \$${amount.toStringAsFixed(2)} registrado',
                      )),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentsPlaceholder extends StatelessWidget {
  const _PaymentsPlaceholder();

  @override
  Widget build(BuildContext context) => const Center(
        child: Text(
          'Vista de Pagos\nen construcción',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      );
}
