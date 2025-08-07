import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/transaction_controller.dart';
import '../models/enums.dart';
import '../models/transaction_model.dart';
import '../utils/app_header.dart';
import 'package:fl_chart/fl_chart.dart';
// Solo importa si realmente tienes la clase. Si no, usa la definición temporal abajo.
// import '../utils/table_calendar.dart';

class TransactionFormView extends StatefulWidget {
  const TransactionFormView({super.key});

  @override
  State<TransactionFormView> createState() => _TransactionFormViewState();
}

class _TransactionFormViewState extends State<TransactionFormView> {
  bool showAllTransactions = false;

  @override
  Widget build(BuildContext context) {
    final txController = Provider.of<TransactionController>(context);

    // Info real de cuentas
    final efectivo = txController.getTotalByAccountType(AccountType.cash);
    final tarjeta  = txController.getTotalByAccountType(AccountType.card);
    final creditos = txController.getTotalByAccountType(AccountType.credit);
    final deudas   = txController.getTotalByAccountType(AccountType.debt);

    // Próximos pagos (ordenados por fecha ascendente)
    final upcoming = txController.transactions
        .where((tx) => tx.dueDate.isAfter(DateTime.now()))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    // Transacciones recientes (las más nuevas primero)
    final recentTx = List<TransactionModel>.from(txController.transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    // Filtra sólo las del mes actual para gráficas/cards
    final now = DateTime.now();
    final monthTx = txController.transactions.where((tx) =>
      tx.date.month == now.month && tx.date.year == now.year
    ).toList();

    // Ingresos/Egresos/pagos/pendiente para cards adicionales
    final ingresosMes = monthTx.where((tx) => tx.type == TransactionType.income).fold<double>(0, (s, tx) => s + tx.amount);
    final egresosMes  = monthTx.where((tx) => tx.type == TransactionType.expense).fold<double>(0, (s, tx) => s + tx.amount);
    final pagosReal   = monthTx.where((tx) => tx.type == TransactionType.payment).fold<double>(0, (s, tx) => s + tx.amount);
    final deudaPend   = txController.getTotalByAccountType(AccountType.debt);

    final size     = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    final crossAxisCount = isTablet ? 4 : 2;
    final availableW     = size.width - 32;
    final spacing        = 8.0;
    final cardW = (availableW - spacing * (crossAxisCount - 1)) / crossAxisCount;
    final iconSize      = isTablet ? 34.0 : 24.0;
    final fontSize      = isTablet ? 15.0 : 12.0;
    final valueFontSize = isTablet ? 18.0 : 14.0;

    // Gráfica simple de ingresos vs egresos este mes
    Widget barChart = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: BarChart(
          BarChartData(
            borderData: FlBorderData(show: false),
            groupsSpace: 24,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 32),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (val, meta) {
                    switch (val.toInt()) {
                      case 0: return Text("Ingresos", style: TextStyle(fontSize: 11));
                      case 1: return Text("Egresos", style: TextStyle(fontSize: 11));
                      case 2: return Text("Pagos", style: TextStyle(fontSize: 11));
                      default: return const SizedBox();
                    }
                  },
                ),
              ),
            ),
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(toY: ingresosMes, width: 16, color: Colors.green)
                ]
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(toY: egresosMes, width: 16, color: Colors.red)
                ]
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(toY: pagosReal, width: 16, color: Colors.blue)
                ]
              ),
            ],
          ),
        ),
      ),
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeader(
              showHome: false,
              onHomeTap: () => Navigator.pushNamedAndRemoveUntil(
                context, '/home_view', (_) => false),
            ),

            // Cards resumen de cuentas
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

            // Cards adicionales
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _StatCard("Ingresos este mes", ingresosMes, Colors.green),
                  _StatCard("Egresos este mes", egresosMes, Colors.red),
                  _StatCard("Pagos realizados", pagosReal, Colors.blue),
                  _StatCard("Deuda pendiente", deudaPend, Colors.orange, isNegative: true),
                ],
              ),
            ),

            // Gráfica simple
            barChart,

            // Balance global
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Card(
                elevation: 1,
                color: const Color(0xFFF6A5C0).withAlpha((.15 * 255).toInt()), // <-- Migrado a .withAlpha
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

            // Próximos pagos/eventos
            Padding(
              padding: const EdgeInsets.only(top: 14, left: 16, right: 16, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Próximos pagos / eventos",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (upcoming.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (_) => TableCalendarView()) // Clase temporal abajo
                        );
                      },
                      child: const Text("Ver todos"),
                    ),
                ],
              ),
            ),
            if (upcoming.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: Text("No tienes pagos próximos registrados")),
              )
            else
              SizedBox(
                height: 170,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: upcoming.length > 5 ? 5 : upcoming.length,
                  itemBuilder: (_, i) {
                    final tx = upcoming[i];
                    return _PaymentCard(tx: tx);
                  },
                ),
              ),

            // Transacciones recientes
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Transacciones recientes",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (recentTx.length > 3)
                    TextButton(
                      onPressed: () {
                        setState(() => showAllTransactions = !showAllTransactions);
                      },
                      child: Text(showAllTransactions ? "Ver menos" : "Ver todo"),
                    ),
                ],
              ),
            ),
            ...List.generate(
              showAllTransactions ? recentTx.length : (recentTx.length > 3 ? 3 : recentTx.length),
              (i) {
                final tx = recentTx[i];
                return _RecentTxCard(tx: tx);
              }
            ),
            if (recentTx.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: Text("No tienes transacciones recientes")),
              ),

            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

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
        color: color.withAlpha((.12 * 255).toInt()), // <-- Migrado a .withAlpha
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

/*─────────────────────────────*/
/*   Cards Adicionales Stats   */
/*─────────────────────────────*/
class _StatCard extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final bool isNegative;
  const _StatCard(this.label, this.value, this.color, {this.isNegative = false, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 144,
      child: Card(
        color: color.withAlpha((.09 * 255).toInt()), // <-- Migrado a .withAlpha
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
              const SizedBox(height: 3),
              Text(
                '${isNegative ? "- " : ""}\$${value.toStringAsFixed(2)}',
                style: TextStyle(
                  color: isNegative ? Colors.red : color,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*──────────────────────────────────────────────*/
/*        Card de próximo pago compacto         */
/*──────────────────────────────────────────────*/
class _PaymentCard extends StatelessWidget {
  final TransactionModel tx;
  const _PaymentCard({required this.tx});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_iconByTxType(tx.type), color: const Color(0xFF837AB6), size: 30),
              const SizedBox(height: 6),
              Text(
                tx.concept,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text('Monto: \$${tx.amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  DateFormat('dd MMM').format(tx.dueDate),
                  style: const TextStyle(color: Colors.black54, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*──────────────────────────────────────────────*/
/*      Card comprimida de transacción          */
/*──────────────────────────────────────────────*/
class _RecentTxCard extends StatelessWidget {
  final TransactionModel tx;
  const _RecentTxCard({required this.tx});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(_iconByTxType(tx.type), color: const Color(0xFF837AB6)),
        title: Text(
          tx.concept,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(DateFormat('dd MMM yyyy').format(tx.date)),
        trailing: Text(
          (tx.type == TransactionType.expense || tx.type == TransactionType.debt)
            ? "-\$${tx.amount.toStringAsFixed(2)}"
            : "+\$${tx.amount.toStringAsFixed(2)}",
          style: TextStyle(
            color: (tx.type == TransactionType.expense || tx.type == TransactionType.debt)
              ? Colors.red
              : Colors.green,
            fontWeight: FontWeight.w700,
            fontSize: 15,
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

/*──────────────────────────────────────────────*/
/*  Widget temporal para TableCalendarView      */
/*  Reemplázalo con tu implementación real      */
/*──────────────────────────────────────────────*/
class TableCalendarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calendario de pagos")),
      body: Center(child: Text("Aquí va el calendario")),
    );
  }
}
