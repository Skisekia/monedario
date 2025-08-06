// 📄 lib/views/add_debt_view.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/debt_controller.dart';
import '../controllers/transaction_controller.dart';
import '../models/enums.dart';
import '../models/transaction_model.dart';
import 'debt_detail_view.dart';
import '../utils/app_header.dart';   // ← ruta donde guardaste el header

/*───────────────────────────────────────────────────────────────*/
/*                       LISTA DE DEUDAS                         */
/*───────────────────────────────────────────────────────────────*/
class AddDebtView extends StatelessWidget {
  const AddDebtView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ───────────── App-Header corporativo (flecha ←) ─────────────
      appBar: AppHeader(
        showHome: false,
        showBack: true,
        onBackTap: () => Navigator.pushNamedAndRemoveUntil(
            context, '/transaction_form_view', (_) => false),
      ),

      // ───────────── Cuerpo ─────────────
      body: Column(
        children: [
          // ───────────── Resumen ─────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _DebtsSummaryCard(),
          ),

          // ───────────── Lista (o placeholder) ─────────────
          Expanded(
            child: Consumer<DebtController>(
              builder: (_, ctrl, __) {
                final debts = ctrl.activeDebts;
                if (debts.isEmpty) {
                  return const Center(child: Text('Sin deudas registradas'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: debts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (_, i) => InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DebtDetailView(debt: debts[i]),
                      ),
                    ),
                    child: _DebtCard(debt: debts[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // ───────────── FAB ─────────────
      floatingActionButton: const _GradientFab(),
    );
  }
}

/*───────────────────────────────────────────────────────────────*/
/*                  TARJETA RESUMEN DE PAGOS                     */
/*───────────────────────────────────────────────────────────────*/
class _DebtsSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final debtsCtrl = context.watch<DebtController>();
    final txCtrl    = context.read<TransactionController>();

    final debts      = debtsCtrl.activeDebts;
    final today      = DateTime.now();
    double perPay(TransactionModel d) =>
        d.numPayments == 0 ? 0 : d.amount / d.numPayments;

    final double pendiente = debts.fold(
        0, (s, d) => s + (d.amount - d.paid));

    final double hoy = debts
        .where((d) => _sameDay(d.dueDate, today))
        .fold(0, (s, d) => s + perPay(d));

    final double mes = debts
        .where((d) =>
            d.dueDate.year == today.year && d.dueDate.month == today.month)
        .fold(0, (s, d) => s + perPay(d));

    final double balance = txCtrl.totalIncome - mes;

    Widget item(String lbl, double val, {Color? color}) => Column(
          children: [
            Text(lbl,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('\$${val.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color ?? Colors.black87)),
          ],
        );

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            item('Pendiente', pendiente),
            item('Hoy', hoy),
            item('Mes', mes),
            item('Balance', balance,
                color: balance >= 0 ? Colors.green : Colors.red),
          ],
        ),
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

/*───────────────────────────────────────────────────────────────*/
/*                  FAB con gradiente corporativo                */
/*───────────────────────────────────────────────────────────────*/
class _GradientFab extends StatelessWidget {
  const _GradientFab();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient:
            LinearGradient(colors: [Color(0xFF7F30FF), Color(0xFF9F7BFF)]),
      ),
      child: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showDebtForm(context),
      ),
    );
  }
}

/*───────────────────────────────────────────────────────────────*/
/*                         TARJETA DE DEUDA                      */
/*───────────────────────────────────────────────────────────────*/
class _DebtCard extends StatelessWidget {
  final TransactionModel debt;
  const _DebtCard({required this.debt});

  @override
  Widget build(BuildContext context) {
    final remaining = debt.amount - debt.paid;
    final df        = DateFormat('dd/MM/yyyy');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // título + restante
          Row(
            children: [
              const Icon(Icons.credit_card_rounded, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(debt.concept,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
              ),
              Text('\$${remaining.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: remaining == 0 ? Colors.green : Colors.black87,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
          const SizedBox(height: 8),

          // etiquetas
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _Chip(label: debt.owner, icon: Icons.person),
              _Chip(label: df.format(debt.dueDate), icon: Icons.event),
              _Chip(label: _freqLabel(debt.frequency), icon: Icons.cached),
              _Chip(
                  label: '${debt.numPayments} pagos',
                  icon: Icons.payments_rounded),
            ],
          ),
        ],
      ),
    );
  }

  String _freqLabel(PaymentFreq f) => switch (f) {
        PaymentFreq.mensual   => 'Mensual',
        PaymentFreq.quincenal => 'Quincenal',
        PaymentFreq.semanal   => 'Semanal',
      };
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _Chip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) => Chip(
        avatar: Icon(icon, size: 16),
        label: Text(label),
        padding: const EdgeInsets.symmetric(horizontal: 6),
      );
}

/*───────────────────────────────────────────────────────────────*/
/*                     MODAL – NUEVA DEUDA                       */
/*───────────────────────────────────────────────────────────────*/
void _showDebtForm(BuildContext context) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _DebtForm(),
    );

/*──────── enum interno frecuencia de pago ────────*/
enum _Freq { mensual, semanal, quincenal }

extension on _Freq {
  String get label => switch (this) {
        _Freq.mensual   => 'Mensual',
        _Freq.semanal   => 'Semanal',
        _Freq.quincenal => 'Quincenal',
      };

  PaymentFreq get toPaymentFreq => switch (this) {
        _Freq.mensual   => PaymentFreq.mensual,
        _Freq.semanal   => PaymentFreq.semanal,
        _Freq.quincenal => PaymentFreq.quincenal,
      };
}

/*───────────────────────────────────────────────────────────────*/
/*                       FORMULARIO NUEVA DEUDA                  */
/*───────────────────────────────────────────────────────────────*/
// … (tu _DebtForm sin cambios) …

/*───────────────────────────────────────────────────────────────*/
/*                       FORMULARIO NUEVA DEUDA                  */
/*───────────────────────────────────────────────────────────────*/
class _DebtForm extends StatefulWidget {
  const _DebtForm();

  @override
  State<_DebtForm> createState() => _DebtFormState();
}

class _DebtFormState extends State<_DebtForm> {
  final _formKey = GlobalKey<FormState>();
  final _conceptCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _creditorCtrl = TextEditingController();
  final _paymentsCtrl = TextEditingController(text: '1');

  DateTime? _dueDate;
  _Freq _frequency = _Freq.mensual;

  @override
  void dispose() {
    _conceptCtrl.dispose();
    _amountCtrl.dispose();
    _creditorCtrl.dispose();
    _paymentsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).viewInsets;

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, padding.bottom + 24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Nueva deuda',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 24),

                // concepto
                TextFormField(
                  controller: _conceptCtrl,
                  decoration: const InputDecoration(labelText: 'Concepto'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),

                // monto por pago
                TextFormField(
                  controller: _amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Monto por pago (\$)'),
                  validator: (v) =>
                      (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Inválido' : null,
                ),
                const SizedBox(height: 16),

                // acreedor
                TextFormField(
                  controller: _creditorCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Persona / Institución'),
                ),
                const SizedBox(height: 16),

                // fecha de primer pago
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(8),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de pago',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.event),
                        const SizedBox(width: 12),
                        Text(
                          _dueDate == null
                              ? 'Seleccionar'
                              : DateFormat('dd/MM/yyyy').format(_dueDate!),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // frecuencia
                DropdownButtonFormField<_Freq>(
                  value: _frequency,
                  decoration: const InputDecoration(labelText: 'Repetición'),
                  items: _Freq.values
                      .map((f) => DropdownMenuItem(
                            value: f,
                            child: Text(f.label),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _frequency = v!),
                ),
                const SizedBox(height: 16),

                // nº de pagos
                TextFormField(
                  controller: _paymentsCtrl,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Número de pagos'),
                  validator: (v) =>
                      (int.tryParse(v ?? '') ?? 0) <= 0 ? 'Inválido' : null,
                ),
                const SizedBox(height: 24),

                // guardar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar'),
                    onPressed: _save,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*────────── helpers ──────────*/
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      initialDate: _dueDate ?? now,
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final perPayment = double.parse(_amountCtrl.text);
    final nPayments = int.parse(_paymentsCtrl.text);
    final total = perPayment * nPayments;

    final debt = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      concept: _conceptCtrl.text.trim(),
      amount: total,
      paid: 0,
      owner: _creditorCtrl.text.trim().isEmpty
          ? 'Sin especificar'
          : _creditorCtrl.text.trim(),
      dueDate: _dueDate ?? DateTime.now(),
      frequency: _frequency.toPaymentFreq,
      numPayments: nPayments,
      type: TransactionType.debt,
      accountType: AccountType.credit,
      createdAt: DateTime.now(),
    );

    context.read<DebtController>().addDebt(debt);
    Navigator.of(context).pop(); // cierra el modal
  }
}
