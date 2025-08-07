import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../controllers/debt_controller.dart';
import '../controllers/transaction_controller.dart';
import '../models/enums.dart';
import '../models/transaction_model.dart';
import '../utils/notifications_view.dart'; // Para showSuccessNotification
import 'debt_detail.dart';

// Enum privado para el formulario.
enum _Freq { diaria, semanal, quincenal, mensual, anual }

extension _FreqExt on _Freq {
  String get label {
    switch (this) {
      case _Freq.diaria: return 'Diaria';
      case _Freq.semanal: return 'Semanal';
      case _Freq.quincenal: return 'Quincenal';
      case _Freq.mensual: return 'Mensual';
      case _Freq.anual: return 'Anual';
    }
  }

  PaymentFreq toPaymentFreq() {
    switch (this) {
      case _Freq.diaria: return PaymentFreq.diaria;
      case _Freq.semanal: return PaymentFreq.semanal;
      case _Freq.quincenal: return PaymentFreq.quincenal;
      case _Freq.mensual: return PaymentFreq.mensual;
      case _Freq.anual: return PaymentFreq.anual;
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
            onPressed: () {},
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

/// FAB que llama el modal card centrado
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

/// Modal tipo card centrado
void _showDebtForm(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => const _DebtFormDialog(),
  );
}

/// ---- Card resumen ----
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

/// ---- Card de cada deuda ----
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

/// ---- MODAL DE NUEVA DEUDA (CARD CENTRADO) ----
class _DebtFormDialog extends StatefulWidget {
  const _DebtFormDialog();

  @override
  State<_DebtFormDialog> createState() => _DebtFormDialogState();
}

class _DebtFormDialogState extends State<_DebtFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _conceptCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _creditorCtrl = TextEditingController();
  final _paymentsCtrl = TextEditingController(text: '1');
  double _total = 0.0;
  bool _saving = false;

  DateTime? _dueDate;
  _Freq _frequency = _Freq.mensual;

  @override
  void initState() {
    super.initState();
    _amountCtrl.addListener(_updateTotal);
    _paymentsCtrl.addListener(_updateTotal);
    _updateTotal();
  }

  void _updateTotal() {
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    final payments = int.tryParse(_paymentsCtrl.text) ?? 0;
    setState(() {
      _total = (amount > 0 && payments > 0) ? amount * payments : 0.0;
    });
  }

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
    // Dimensiones responsivas
    final mq = MediaQuery.of(context);
    final isTablet = mq.size.width > 600;
    final maxWidth = isTablet ? 420.0 : mq.size.width * 0.92;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: maxWidth,
          margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Nueva deuda',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF250E2C),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Concepto
                  TextFormField(
                    controller: _conceptCtrl,
                    decoration: InputDecoration(
                      labelText: 'Concepto',
                      prefixIcon: const Icon(Icons.description_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF4F6FA),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 16),

                  // Monto del pago
                  TextFormField(
                    controller: _amountCtrl,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Monto del pago (\$)',
                      prefixIcon: const Icon(Icons.attach_money_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF4F6FA),
                    ),
                    validator: (v) =>
                        (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Inválido' : null,
                  ),
                  const SizedBox(height: 16),

                  // Número de pagos
                  TextFormField(
                    controller: _paymentsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Número de pagos',
                      prefixIcon: const Icon(Icons.payments_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF4F6FA),
                    ),
                    validator: (v) =>
                        (int.tryParse(v ?? '') ?? 0) <= 0 ? 'Mínimo 1' : null,
                  ),
                  const SizedBox(height: 16),

                  // Monto total (solo lectura)
                  TextFormField(
                    readOnly: true,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Monto total',
                      prefixIcon: const Icon(Icons.calculate_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                    controller: TextEditingController(
                      text: '\$${_total.toStringAsFixed(2)}',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Persona / Institución
                  TextFormField(
                    controller: _creditorCtrl,
                    decoration: InputDecoration(
                      labelText: 'Persona / Institución',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF4F6FA),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Fecha de pago
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Fecha de pago',
                        prefixIcon: const Icon(Icons.event_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF4F6FA),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            _dueDate == null
                                ? 'Seleccionar'
                                : DateFormat('dd/MM/yyyy').format(_dueDate!),
                            style: TextStyle(
                                color: _dueDate == null
                                    ? Colors.grey
                                    : Colors.black87,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Repetición (Dropdown)
                  DropdownButtonFormField<_Freq>(
                    value: _frequency,
                    decoration: InputDecoration(
                      labelText: 'Frecuencia de pago',
                      prefixIcon: const Icon(Icons.repeat_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF4F6FA),
                    ),
                    items: _Freq.values
                        .map((f) => DropdownMenuItem(
                            value: f, child: Text(f.label)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _frequency = v!),
                  ),
                  const SizedBox(height: 22),

                  // Botón guardar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: _saving
                          ? const SizedBox(
                              width: 22, height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.check_circle),
                      label: const Text('Guardar deuda', style: TextStyle(fontSize: 17)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        backgroundColor: const Color(0xFF837AB6),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _saving ? null : _save,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      initialDate: _dueDate ?? now,
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dueDate == null) {
      showErrorNotification(context, 'Selecciona una fecha de pago');
      return;
    }

    setState(() => _saving = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showErrorNotification(context, 'Usuario no autenticado');
      setState(() => _saving = false);
      return;
    }

    try {
      final nuevaDeuda = TransactionModel(
        id: const Uuid().v4(),
        owner: user.uid,
        type: TransactionType.debt,
        accountType: AccountType.personal,
        createdAt: DateTime.now(),
        concept: _conceptCtrl.text.trim(),
        amount: _total,
        paid: 0,
        dueDate: _dueDate!,
        frequency: _frequency.toPaymentFreq(),
        numPayments: int.tryParse(_paymentsCtrl.text) ?? 1,
        date: DateTime.now(),
      );

      context.read<DebtController>().addDebt(nuevaDeuda);

      if (!mounted) return;
      showSuccessNotification(context, "¡Deuda registrada exitosamente!");
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      showErrorNotification(context, "No se pudo registrar la deuda");
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
