import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/debt_controller.dart';   // para conocer las deudas
import '../utils/forms_view.dart' show PaymentForm;

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DebtController(), // mismo controller para example
      child: Scaffold(
        appBar: AppBar(title: const Text('Pagos')),
        body: const _PaymentsPlaceholder(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => PaymentForm(
              onSubmit: (amount, debtId) {
                // aquí llamarías a tu controlador de pagos
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pago \$${amount.toStringAsFixed(2)} guardado')),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Placeholder mientras implementas la lógica real de pagos
class _PaymentsPlaceholder extends StatelessWidget {
  const _PaymentsPlaceholder();

  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          'Vista de Pagos\nen construcción',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      );
}
