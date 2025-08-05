import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';
import '../utils/app_header.dart';
import '../models/enums.dart';

class TransactionFormView extends StatefulWidget {
  const TransactionFormView({super.key});

  @override
  State<TransactionFormView> createState() => _TransactionFormViewState();
}

class _TransactionFormViewState extends State<TransactionFormView> {
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _counterpartyCtrl = TextEditingController();
  final _interestCtrl = TextEditingController();
  final _frequencyCtrl = TextEditingController();
  final _numPaymentsCtrl = TextEditingController();
  final String title = "Cartera";

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

    double efectivo = controller.getTotalByAccountType(AccountType.cash);
    double tarjeta  = controller.getTotalByAccountType(AccountType.card);
    double creditos = controller.getTotalByAccountType(AccountType.credit);
    double deudas   = controller.getTotalByAccountType(AccountType.debt);

    final List<TransactionModel> upcomingTxs = controller.transactions
        .where((tx) => tx.date.isAfter(DateTime.now()))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final double screenWidth   = MediaQuery.of(context).size.width;
    final bool   isTablet      = screenWidth > 600;
    final double cardWidth     = isTablet ? 125 : 85;
    final double cardHeight    = isTablet ? 98 : 72; // sigue recibiéndose aunque ya no se fija
    final double iconSize      = isTablet ? 32 : 22;
    final double fontSize      = isTablet ? 14 : 11;
    final double valueFontSize = isTablet ? 17 : 13;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeader(
              showHome: false,
              onHomeTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home_view', (route) => false);
              },
            ),

            // ---------- RESUMEN ----------
            Padding(
              padding: const EdgeInsets.only(
                  left: 7, right: 7, top: 10, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AccountSummaryCard(
                    title: "Efectivo",
                    icon: Icons.payments_rounded,
                    amount: efectivo,
                    color: const Color(0xFF250E2C),
                    cardWidth: cardWidth,
                    cardHeight: cardHeight,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    valueFontSize: valueFontSize,
                  ),
                  _AccountSummaryCard(
                    title: "Tarjeta",
                    icon: Icons.credit_card_rounded,
                    amount: tarjeta,
                    color: const Color(0xFF837AB6),
                    cardWidth: cardWidth,
                    cardHeight: cardHeight,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    valueFontSize: valueFontSize,
                  ),
                  _AccountSummaryCard(
                    title: "Créditos",
                    icon: Icons.account_balance_wallet_rounded,
                    amount: creditos,
                    color: const Color(0xFFF6A5C0),
                    cardWidth: cardWidth,
                    cardHeight: cardHeight,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    valueFontSize: valueFontSize,
                  ),
                  _AccountSummaryCard(
                    title: "Deudas",
                    icon: Icons.warning_amber_rounded,
                    amount: deudas,
                    color: Colors.red.shade300,
                    isNegative: true,
                    cardWidth: cardWidth,
                    cardHeight: cardHeight,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    valueFontSize: valueFontSize,
                  ),
                ],
              ),
            ),

            // ---------- BALANCE ----------
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              child: Card(
                elevation: 1,
                color: const Color(0xFFF6A5C0).withOpacity(0.18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 22 : 11,
                      vertical: isTablet ? 13 : 9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("Ingresos",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize)),
                          Text(
                            '\$${controller.totalIncome.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                                fontSize: valueFontSize),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Egresos",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize)),
                          Text(
                            '\$${controller.totalExpense.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                                fontSize: valueFontSize),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Balance",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize)),
                          Text(
                            '\$${(controller.totalIncome - controller.totalExpense).toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w700,
                                fontSize: valueFontSize),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ---------- PRÓXIMOS PAGOS ----------
            Padding(
              padding: const EdgeInsets.only(
                  top: 12, left: 16, right: 16, bottom: 8),
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
                      title: Text(
                        tx.description ??
                            tx.type.toString().split('.').last,
                        style: TextStyle(fontSize: fontSize),
                      ),
                      subtitle:
                          Text("Monto: \$${tx.amount.toStringAsFixed(2)}"),
                      trailing:
                          Text(DateFormat('dd MMM').format(tx.date)),
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
}

class _AccountSummaryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final double amount;
  final Color color;
  final bool isNegative;
  final double cardWidth;
  final double cardHeight; // sigue recibiéndose para no romper llamadas
  final double iconSize;
  final double fontSize;
  final double valueFontSize;

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
        width: cardWidth, // altura dinámica → sin overflow vertical
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
