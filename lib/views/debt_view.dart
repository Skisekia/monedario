import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/debt_controller.dart';
import '../models/transaction_model.dart';
import '../utils/forms_view.dart' show DebtForm;
import 'debt_detail_view.dart';

class DebtView extends StatelessWidget {
  const DebtView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Provee el controller para Consumer-s debajo
      create: (_) => DebtController(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Deudas')),
        body: Consumer<DebtController>(
          builder: (_, ctrl, __) {
            final debts = ctrl.activeDebts;
            if (debts.isEmpty) {
              return const Center(child: Text('Sin deudas registradas'));
            }
            return ListView.builder(
              itemCount: debts.length,
              itemBuilder: (_, i) => _DebtCard(debt: debts[i]),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => DebtForm(
              onSubmit: (d) => context.read<DebtController>().addDebt(d),
            ),
          ),
        ),
      ),
    );
  }
}

/*─────────────────────────────────────────────────────────────────*/
/*   Card individual                                               */
/*─────────────────────────────────────────────────────────────────*/
class _DebtCard extends StatelessWidget {
  final TransactionModel debt;
  const _DebtCard({required this.debt});

  @override
  Widget build(BuildContext context) {
    final remaining = debt.amount - debt.paid;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.account_balance_wallet_rounded),
        title: Text(debt.description ?? 'Sin descripción'),
        subtitle: Text('Restante: \$${remaining.toStringAsFixed(2)}'),
        trailing: remaining == 0
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DebtDetailView(debt: debt)),
        ),
      ),
    );
  }
}
