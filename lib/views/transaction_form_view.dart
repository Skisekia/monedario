import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Para formato de fecha
import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';
import '../utils/app_header.dart';
import '../models/enums.dart'; //para tipos de transacción

class TransactionFormView extends StatefulWidget {
  const TransactionFormView({super.key});

  @override
  State<TransactionFormView> createState() => _TransactionFormViewState();
}

class _TransactionFormViewState extends State<TransactionFormView> {
  // Controllers de los campos
  //TransactionType? _selectedType;
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _counterpartyCtrl = TextEditingController();
  final _interestCtrl = TextEditingController();
  final _frequencyCtrl = TextEditingController();
  final _numPaymentsCtrl = TextEditingController();
  final String title = "Cartera"; // Título de la vista

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    _counterpartyCtrl.dispose();
    _interestCtrl.dispose();
    _frequencyCtrl.dispose();
    _numPaymentsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TransactionController>(context);

    // Calcula totales por tipo de cuenta
    double efectivo = controller.getTotalByAccountType(AccountType.cash);
    double tarjeta = controller.getTotalByAccountType(AccountType.card);
    double creditos = controller.getTotalByAccountType(AccountType.credit);
    double deudas = controller.getTotalByAccountType(AccountType.debt);

    // Próximos pagos/fechas (puedes mejorar el filtro)
    final List<TransactionModel> upcomingTxs = controller.transactions
        .where((tx) => tx.date.isAfter(DateTime.now()))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return Column(
      children: [
        AppHeader(
          isHome: false,
          //title: "Cartera",
          onHomeTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),

        // ----- RESUMEN DE CARTERA -----
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _AccountSummaryCard(
                  title: "Efectivo",
                  icon: Icons.payments_rounded,
                  amount: efectivo,
                  color: Colors.green.shade400,
                ),
                _AccountSummaryCard(
                  title: "Tarjeta",
                  icon: Icons.credit_card_rounded,
                  amount: tarjeta,
                  color: Colors.blue.shade400,
                ),
                _AccountSummaryCard(
                  title: "Créditos",
                  icon: Icons.account_balance_wallet_rounded,
                  amount: creditos,
                  color: Colors.deepPurple.shade400,
                ),
                _AccountSummaryCard(
                  title: "Deudas",
                  icon: Icons.warning_amber_rounded,
                  amount: deudas,
                  color: Colors.red.shade300,
                  isNegative: true,
                ),
              ],
            ),
          ),
        ),

        // ------- ACCESOS RÁPIDOS -------
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _QuickActionButton(
                icon: Icons.trending_up_rounded,
                label: "Ingreso",
                color: Colors.green,
                onTap: () => _showAddTxModal(context, TransactionType.income),
              ),
              _QuickActionButton(
                icon: Icons.trending_down_rounded,
                label: "Gasto",
                color: Colors.red,
                onTap: () => _showAddTxModal(context, TransactionType.expense),
              ),
              _QuickActionButton(
                icon: Icons.swap_horiz_rounded,
                label: "Transacción",
                color: Colors.blueGrey,
                onTap: () => _showAddTxModal(context, TransactionType.transfer),
              ),
              _QuickActionButton(
                icon: Icons.request_quote_rounded,
                label: "Préstamo",
                color: Colors.deepPurple,
                onTap: () => _showAddTxModal(context, TransactionType.loanTaken),
              ),
              _QuickActionButton(
                icon: Icons.account_balance_rounded,
                label: "Pago",
                color: Colors.teal,
                onTap: () => _showAddTxModal(context, TransactionType.payment),
              ),
            ],
          ),
        ),

        // ---------- BALANCE Y GRÁFICA ----------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
          child: Card(
            elevation: 1,
            color: Colors.blue.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text("Ingresos", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('\$${controller.totalIncome.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w700, fontSize: 18)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Egresos", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('\$${controller.totalExpense.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700, fontSize: 18)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Balance", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        '\$${(controller.totalIncome - controller.totalExpense).toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w700, fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // --------- CALENDARIO Y PRÓXIMOS PAGOS ----------
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 20, right: 20, bottom: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Próximos pagos / eventos",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: upcomingTxs.isEmpty
              ? const Center(child: Text("No tienes pagos próximos registrados"))
              : ListView.builder(
                  itemCount: upcomingTxs.length > 5 ? 5 : upcomingTxs.length,
                  itemBuilder: (context, i) {
                    final tx = upcomingTxs[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      child: ListTile(
                        leading: Icon(_iconByTxType(tx.type), color: Colors.blueAccent),
                        title: Text(tx.description ?? tx.type.toString().split('.').last),
                        subtitle: Text("Monto: \$${tx.amount.toStringAsFixed(2)}"),
                        trailing: Text(DateFormat('dd MMM').format(tx.date)),
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  // ----- MODAL PARA AGREGAR TRANSACCIÓN -----
  void _showAddTxModal(BuildContext context, TransactionType initialType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Agregar ${_friendlyName(initialType)}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 12),
              // Aquí pon los campos relevantes (puedes reusar tu formulario actual, modularizándolo)
              // Ejemplo: reutiliza tu formulario o crea uno más compacto para el modal
              // ...
            ],
          ),
        ),
      ),
    );
  }
}

// ------------- WIDGETS REUTILIZABLES -----------------

class _AccountSummaryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final double amount;
  final Color color;
  final bool isNegative;

  const _AccountSummaryCard({
    required this.title,
    required this.icon,
    required this.amount,
    required this.color,
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color..withAlpha((.18 * 255).toInt()),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.only(right: 14),
      child: SizedBox(
        width: 140,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 6),
              Text(
                '${isNegative ? "- " : ""}\$${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: isNegative ? Colors.red : color,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color..withAlpha((.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// Helpers (puedes extraer a utils):
IconData _iconByTxType(TransactionType type) {
  switch (type) {
    case TransactionType.income: return Icons.trending_up_rounded;
    case TransactionType.expense: return Icons.trending_down_rounded;
    case TransactionType.transfer: return Icons.swap_horiz_rounded;
    case TransactionType.loanGiven: return Icons.call_made_rounded;
    case TransactionType.loanTaken: return Icons.call_received_rounded;
    case TransactionType.payment: return Icons.request_quote_rounded;
    //default: return Icons.account_balance_wallet_rounded;
  }
}
String _friendlyName(TransactionType t) {
  switch (t) {
    case TransactionType.income: return "Ingreso";
    case TransactionType.expense: return "Gasto";
    case TransactionType.transfer: return "Transacción";
    case TransactionType.loanGiven: return "Préstamo dado";
    case TransactionType.loanTaken: return "Préstamo recibido";
    case TransactionType.payment: return "Pago";
    //default: return "Transacción";
  }
}
