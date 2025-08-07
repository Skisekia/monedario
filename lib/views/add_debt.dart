// 📄 lib/views/add_debt_view.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../controllers/debt_controller.dart';
import '../controllers/transaction_controller.dart';
import '../models/enums.dart';
import '../models/transaction_model.dart';
import 'debt_detail.dart';

// Enum privado para el formulario.
enum _Freq { diaria, semanal, quincenal, mensual, anual }

extension _FreqExt on _Freq {
  String get label {
    switch (this) {
      case _Freq.diaria:
        return 'Diaria';
      case _Freq.semanal:
        return 'Semanal';
      case _Freq.quincenal:
        return 'Quincenal';
      case _Freq.mensual:
        return 'Mensual';
      case _Freq.anual:
        return 'Anual';
    }
  }

  PaymentFreq toPaymentFreq() {
    switch (this) {
      case _Freq.diaria:
        return PaymentFreq.diaria;
      case _Freq.semanal:
        return PaymentFreq.semanal;
      case _Freq.quincenal:
        return PaymentFreq.quincenal;
      case _Freq.mensual:
        return PaymentFreq.mensual;
      case _Freq.anual:
        return PaymentFreq.anual;
    }
  }
}

class AddDebtView extends StatelessWidget {
  const AddDebtView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Mis Deudas', style: TextStyle(color: Colors.black87)),
        iconTheme: const IconThemeData(color: Colors.black54),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _showCalendarModal(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _DebtsSummaryCard(),
          ),
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
                          builder: (_) => DebtDetail(debt: debts[i])),
                    ),
                    child: _DebtCard(debt: debts[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: const _GradientFab(),
    );
  }

  void _showCalendarModal(BuildContext context) {
    final debts = context.read<DebtController>().activeDebts;
    final dates = debts
        .map((d) => DateTime(d.dueDate.year, d.dueDate.month, d.dueDate.day))
        .toSet();

    final today = DateTime.now();
    final initial = dates.contains(DateTime(today.year, today.month, today.day))
        ? today
        : (dates.isNotEmpty ? dates.first : today);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Fechas de Pago',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          CalendarDatePicker(
            initialDate: initial,
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            selectableDayPredicate: (day) =>
                dates.contains(DateTime(day.year, day.month, day.day)),
            onDateChanged: (_) {},
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: dates.map((d) {
              final label = DateFormat('dd/MM/yyyy').format(d);
              return Chip(label: Text(label));
            }).toList(),
          ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }
}

void _showDebtForm(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _DebtForm(),
  );
}

class _DebtsSummaryCard extends StatelessWidget {
  const _DebtsSummaryCard();

  @override
  Widget build(BuildContext context) {
    final debtsCtrl = context.watch<DebtController>();
    final txCtrl = context.read<TransactionController>();
    final debts = debtsCtrl.activeDebts;
    final now = DateTime.now();

    double perPay(TransactionModel d) =>
        d.numPayments == 0 ? 0 : d.amount / d.numPayments;

    final pendiente =
        debts.fold<double>(0, (s, d) => s + (d.amount - d.paid));
    final hoy = debts
        .where((d) =>
            d.dueDate.year == now.year &&
            d.dueDate.month == now.month &&
            d.dueDate.day == now.day)
        .fold<double>(0, (s, d) => s + perPay(d));
    final mes = debts
        .where(
            (d) => d.dueDate.year == now.year && d.dueDate.month == now.month)
        .fold<double>(0, (s, d) => s + perPay(d));
    final balance = txCtrl.totalIncome - mes;

    Widget item(String lbl, double val, {Color? color}) => Column(
          children: [
            Text(lbl,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600)),
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
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
}

class _GradientFab extends StatelessWidget {
  const _GradientFab();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      child: const Icon(Icons.add, color: Color(0xFF7F30FF)),
      onPressed: () => _showDebtForm(context),
    );
  }
}

class _DebtCard extends StatelessWidget {
  final TransactionModel debt;
  const _DebtCard({required this.debt});

  @override
  Widget build(BuildContext context) {
    final remaining = debt.amount - debt.paid;
    final df = DateFormat('dd/MM/yyyy');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: const Color(0xFFF7F2FF),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.credit_card_rounded, size: 30),
            const SizedBox(width: 10),
            Expanded(
                child: Text(debt.concept,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16))),
            Text('\$${remaining.toStringAsFixed(2)}',
                style: TextStyle(
                    color:
                        remaining == 0 ? Colors.green : Colors.black87,
                    fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 12, runSpacing: 6, children: [
            _Chip(label: debt.owner, icon: Icons.person),
            _Chip(label: df.format(debt.dueDate), icon: Icons.event),
            _Chip(label: debt.frequency.label, icon: Icons.cached),
            _Chip(label: '${debt.numPayments} pagos', icon: Icons.payments),
          ]),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _Chip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) =>
      Chip(avatar: Icon(icon, size: 16), label: Text(label));
}

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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: bottomInset + 16, left: 24, right: 24),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Nueva deuda',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildInput(
                      controller: _conceptCtrl,
                      hint: 'Concepto',
                      icon: Icons.description_rounded,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Requerido'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    _buildInput(
                      controller: _amountCtrl,
                      hint: 'Monto (\$)',
                      icon: Icons.attach_money_rounded,
                      keyboard: TextInputType.number,
                      validator: (v) =>
                          (double.tryParse(v ?? '') ?? 0) <= 0
                              ? 'Inválido'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    _buildInput(
                      controller: _creditorCtrl,
                      hint: 'Persona / Institución',
                      icon: Icons.person_rounded,
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: _decoration('Fecha pago'),
                        child: Row(children: [
                          const Icon(Icons.event,
                              color: Colors.black54),
                          const SizedBox(width: 8),
                          Text(
                            _dueDate == null
                                ? 'Seleccionar'
                                : DateFormat('dd/MM/yyyy')
                                    .format(_dueDate!),
                            style: TextStyle(
                                color: _dueDate == null
                                    ? Colors.grey
                                    : Colors.black87),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<_Freq>(
                      value: _frequency,
                      decoration: _decoration('Repetición'),
                      items: _Freq.values
                          .map((f) => DropdownMenuItem(
                              value: f, child: Text(f.label)))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _frequency = v!),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 140,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _save,
                        child: const Text('Guardar'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(22),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label) =>
      InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF4F6FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      );

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: validator,
        decoration:
            _decoration(hint).copyWith(
          prefixIcon: Icon(icon, color: Colors.black54),
        ),
      );

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked =
        await showDatePicker(
      context: context,
      firstDate:
          DateTime(now.year - 1),
      lastDate:
          DateTime(now.year + 5),
      initialDate: _dueDate ?? now,
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una fecha de pago')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario no autenticado')),
      );
      return;
    }

    // --- ATENCIÓN AQUÍ: estos deben ser enums, no strings ---
    final nuevaDeuda = TransactionModel(
      id: const Uuid().v4(),
      owner: user.uid,
      type: TransactionType.debt,          // ← Enum
      accountType: AccountType.personal,   // ← Enum
      createdAt: DateTime.now(),
      concept: _conceptCtrl.text.trim(),
      amount: double.parse(_amountCtrl.text),
      paid: 0,
      dueDate: _dueDate!,
      frequency: _frequency.toPaymentFreq(),
      numPayments: int.tryParse(_paymentsCtrl.text) ?? 1,
      // otros campos...
    );

    context.read<DebtController>().addDebt(nuevaDeuda);
    Navigator.pop(context);
  }
}
