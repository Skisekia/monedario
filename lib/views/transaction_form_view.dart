import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../controllers/transaction_controller.dart';
// ‼️  ya no es necesario si no usas TransactionModel explícitamente
// import '../models/transaction_model.dart';
import '../models/enums.dart';
import '../utils/app_header.dart';

class TransactionFormView extends StatefulWidget {
  const TransactionFormView({super.key});

  @override
  State<TransactionFormView> createState() => _TransactionFormViewState();
}

class _TransactionFormViewState extends State<TransactionFormView> {
  /* (… controllers reservados para futuros formularios …) */
  final _amountCtrl        = TextEditingController();
  final _descCtrl          = TextEditingController();
  final _counterpartyCtrl  = TextEditingController();
  final _interestCtrl      = TextEditingController();
  final _frequencyCtrl     = TextEditingController();
  final _numPaymentsCtrl   = TextEditingController();

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

    /* ── Totales por tipo de cuenta ── */
    final efectivo = controller.getTotalByAccountType(AccountType.cash);
    final tarjeta  = controller.getTotalByAccountType(AccountType.card);
    final creditos = controller.getTotalByAccountType(AccountType.credit);
    final deudas   = controller.getTotalByAccountType(AccountType.debt);

    /* ── Próximos eventos (ordenados) ── */
    final upcomingTxs = controller.transactions
        .where((tx) => tx.dueDate.isAfter(DateTime.now()))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    /* ── Adaptativo phone / tablet ── */
    final screenW       = MediaQuery.of(context).size.width;
    final isTablet      = screenW > 600;
    final cardW         = isTablet ? 125.0 :  85.0;
    final cardH         = isTablet ?  98.0 :  72.0;     // (no se usa dentro)
    final iconSize      = isTablet ?  32.0 :  22.0;
    final fontSize      = isTablet ?  14.0 :  11.0;
    final valueFontSize = isTablet ?  17.0 :  13.0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /* ---------- ENCABEZADO ---------- */
            AppHeader(
              showHome: false,
              onHomeTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/home_view', (_) => false),
            ),

            /* ---------- RESUMEN CUENTAS ---------- */
            Padding(
              padding: const EdgeInsets.fromLTRB(7, 10, 7, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AccountSummaryCard(
                    title: "Efectivo",
                    icon : Icons.payments_rounded,
                    amount: efectivo,
                    color : const Color(0xFF250E2C),
                    cardWidth: cardW,
                    cardHeight: cardH,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    valueFontSize: valueFontSize,
                  ),
                  _AccountSummaryCard(
                    title: "Tarjeta",
                    icon : Icons.credit_card_rounded,
                    amount: tarjeta,
                    color : const Color(0xFF837AB6),
                    cardWidth: cardW,
                    cardHeight: cardH,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    valueFontSize: valueFontSize,
                  ),
                  _AccountSummaryCard(
                    title: "Créditos",
                    icon : Icons.account_balance_wallet_rounded,
                    amount: creditos,
                    color : const Color(0xFFF6A5C0),
                    cardWidth: cardW,
                    cardHeight: cardH,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    valueFontSize: valueFontSize,
                  ),
                  _AccountSummaryCard(
                    title: "Deudas",
                    icon : Icons.warning_amber_rounded,
                    amount: deudas,
                    color : Colors.red.shade300,
                    isNegative: true,
                    cardWidth: cardW,
                    cardHeight: cardH,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    valueFontSize: valueFontSize,
                  ),
                ],
              ),
            ),

            /* ---------- BALANCE ---------- */
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              child: Card(
                elevation: 1,
                color: const Color(0xFFF6A5C0).withOpacity(.18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 22.0 : 11.0,
                      vertical  : isTablet ? 13.0 :  9.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _amountColumn("Ingresos", controller.totalIncome,
                          fontSize, valueFontSize, Colors.green),
                      _amountColumn("Egresos", controller.totalExpense,
                          fontSize, valueFontSize, Colors.red),
                      _amountColumn(
                          "Balance",
                          controller.totalIncome - controller.totalExpense,
                          fontSize,
                          valueFontSize,
                          Colors.blue),
                    ],
                  ),
                ),
              ),
            ),

            /* ---------- PRÓXIMOS PAGOS ---------- */
            Padding(
              padding:
                  const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Próximos pagos / eventos",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (upcomingTxs.isEmpty)
              const Center(child: Text("No tienes pagos próximos registrados"))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: upcomingTxs.length > 5 ? 5 : upcomingTxs.length,
                itemBuilder: (context, i) {
                  final tx = upcomingTxs[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 5),
                    child: ListTile(
                      leading: Icon(_iconByTxType(tx.type),
                          color: const Color(0xFF837AB6)),
                      title: Text(tx.concept, style: TextStyle(fontSize: fontSize)),
                      subtitle:
                          Text("Monto: \$${tx.amount.toStringAsFixed(2)}"),
                      trailing:
                          Text(DateFormat('dd MMM').format(tx.dueDate)),
                    ),
                  );
                },
              ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  /* helper para las columnas de balance */
  Widget _amountColumn(String label, double value, double labelFSize,
      double valueFSize, Color color) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: labelFSize)),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: valueFSize),
        ),
      ],
    );
  }
}

/*───────────────────────────────────────────────────────────────*/
/*          CARD CON RESUMEN DE CADA CUENTA (efectivo, …)        */
/*───────────────────────────────────────────────────────────────*/
class _AccountSummaryCard extends StatelessWidget {
  final String   title;
  final IconData icon;
  final double   amount;
  final Color    color;
  final bool     isNegative;
  final double   cardWidth;
  final double   cardHeight; // (no se usa, pero se mantiene por compat.)
  final double   iconSize;
  final double   fontSize;
  final double   valueFontSize;

  const _AccountSummaryCard({
    required this.title,
    required this.icon,
    required this.amount,
    required this.color,
    this.isNegative = false,
    required this.cardWidth,
    required this.cardHeight,
    required this.iconSize,
    required this.fontSize,
    required this.valueFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(.14),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: cardWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: iconSize),
              const SizedBox(height: 3),
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: fontSize)),
              const SizedBox(height: 2),
              Text(
                '${isNegative ? "- " : ""}\$${amount.toStringAsFixed(2)}',
                style: TextStyle(
                    color: isNegative ? Colors.red : color,
                    fontWeight: FontWeight.w700,
                    fontSize: valueFontSize),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*───────────────────────────────────────────────────────────────*/
/*              Ícono sugerido según el tipo de transacción      */
/*───────────────────────────────────────────────────────────────*/
IconData _iconByTxType(TransactionType type) {
  switch (type) {
    case TransactionType.income:
      return Icons.trending_up_rounded;
    case TransactionType.expense:
      return Icons.trending_down_rounded;
    case TransactionType.transfer:
      return Icons.swap_horiz_rounded;
    case TransactionType.loanGiven:
      return Icons.call_made_rounded;
    case TransactionType.loanTaken:
      return Icons.call_received_rounded;
    case TransactionType.payment:
      return Icons.request_quote_rounded;
    case TransactionType.debt:
      return Icons.account_balance_wallet_rounded;
  }
}
