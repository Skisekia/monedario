import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../controllers/transaction_controller.dart';
import '../models/enums.dart';
import '../utils/app_header.dart';

class TransactionFormView extends StatefulWidget {
  const TransactionFormView({super.key});

  @override
  State<TransactionFormView> createState() => _TransactionFormViewState();
}

class _TransactionFormViewState extends State<TransactionFormView> {
  /*  ────────────    futuros formularios    ──────────── */
  final _amountCtrl       = TextEditingController();
  final _descCtrl         = TextEditingController();
  final _counterpartyCtrl = TextEditingController();
  final _interestCtrl     = TextEditingController();
  final _frequencyCtrl    = TextEditingController();
  final _numPaymentsCtrl  = TextEditingController();

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
    final txController = Provider.of<TransactionController>(context);

    /* ─── Totales por tipo de cuenta ─── */
    final efectivo = txController.getTotalByAccountType(AccountType.cash);
    final tarjeta  = txController.getTotalByAccountType(AccountType.card);
    final creditos = txController.getTotalByAccountType(AccountType.credit);
    final deudas   = txController.getTotalByAccountType(AccountType.debt);

    /* ─── Próximos pagos ordenados ─── */
    final upcoming = txController.transactions
        .where((tx) => tx.dueDate.isAfter(DateTime.now()))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    final size     = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    /* 4-columnas en tablet, 2-columnas en móvil */
    final crossAxisCount = isTablet ? 4 : 2;
    final availableW     = size.width - 32 /*padding horizontal total*/;
    final spacing        = 8.0;
    final cardW = (availableW - spacing * (crossAxisCount - 1)) / crossAxisCount;

    /* tamaños adaptativos para texto / icono */
    final iconSize      = isTablet ? 34.0 : 24.0;
    final fontSize      = isTablet ? 15.0 : 12.0;
    final valueFontSize = isTablet ? 18.0 : 14.0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /* ────────── ENCABEZADO ────────── */
            AppHeader(
              showHome: false,
              onHomeTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/home_view', (_) => false),
            ),

            /* ────────── RESUMEN CUENTAS ────────── */
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  _AccountSummaryCard(
                    title: "Efectivo",
                    icon : Icons.payments_rounded,
                    amount: efectivo,
                    color : const Color(0xFF250E2C),
                    cardWidth: cardW,
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
                    iconSize: iconSize,
                    fontSize: fontSize,
                    valueFontSize: valueFontSize,
                  ),
                ],
              ),
            ),

            /* ────────── BALANCE GLOBAL ────────── */
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Card(
                elevation: 1,
                color: const Color(0xFFF6A5C0).withOpacity(.15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24 : 12,
                      vertical  : isTablet ? 14 : 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _amountColumn("Ingresos", txController.totalIncome,
                          fontSize, valueFontSize, Colors.green),
                      _amountColumn("Egresos", txController.totalExpense,
                          fontSize, valueFontSize, Colors.red),
                      _amountColumn(
                          "Balance",
                          txController.totalIncome - txController.totalExpense,
                          fontSize,
                          valueFontSize,
                          Colors.blue),
                    ],
                  ),
                ),
              ),
            ),

            /* ────────── PRÓXIMOS PAGOS ────────── */
            Padding(
              padding:
                  const EdgeInsets.only(top: 14, left: 16, right: 16, bottom: 8),
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
            if (upcoming.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: Text("No tienes pagos próximos registrados")),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: upcoming.length,
                itemBuilder: (_, i) {
                  final tx = upcoming[i];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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

            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  /*  mini-helper para columnas del balance  */
  Widget _amountColumn(String label, double value, double labelF,
      double valueF, Color color) {
    return Column(
      children: [
        Text(label,
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: labelF)),
        Text('\$${value.toStringAsFixed(2)}',
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: valueF)),
      ],
    );
  }
}

/*──────────────────────────────────────────────*/
/*          Card resumen cuenta individual      */
/*──────────────────────────────────────────────*/
class _AccountSummaryCard extends StatelessWidget {
  final String   title;
  final IconData icon;
  final double   amount;
  final Color    color;
  final bool     isNegative;
  final double   cardWidth;
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
    required this.iconSize,
    required this.fontSize,
    required this.valueFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      child: Card(
        color: color.withOpacity(.12),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: iconSize),
              const SizedBox(height: 4),
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

/*──────────────────────────────────────────────*/
/*   Ícono sugerido según tipo de transacción   */
/*──────────────────────────────────────────────*/
IconData _iconByTxType(TransactionType type) {
  switch (type) {
    case TransactionType.income:      return Icons.trending_up_rounded;
    case TransactionType.expense:     return Icons.trending_down_rounded;
    case TransactionType.transfer:    return Icons.swap_horiz_rounded;
    case TransactionType.loanGiven:   return Icons.call_made_rounded;
    case TransactionType.loanTaken:   return Icons.call_received_rounded;
    case TransactionType.payment:     return Icons.request_quote_rounded;
    case TransactionType.debt:        return Icons.account_balance_wallet_rounded;
    case TransactionType.loan:        return Icons.account_balance_wallet_rounded;
  }
}
