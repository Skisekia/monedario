// lib/views/transaction_form_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';

class TransactionFormView extends StatefulWidget {
  const TransactionFormView({super.key});

  @override
  State<TransactionFormView> createState() => _TransactionFormViewState();
}

class _TransactionFormViewState extends State<TransactionFormView> {
  TransactionType? _selectedType;
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _counterpartyCtrl = TextEditingController();
  final _interestCtrl = TextEditingController();
  final _frequencyCtrl = TextEditingController();
  final _numPaymentsCtrl = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Transacción')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Tipo de transacción
            DropdownButtonFormField<TransactionType>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: 'Tipo de transacción'),
              items: TransactionType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedType = val),
            ),
            const SizedBox(height: 16),

            // Monto
            TextField(
              controller: _amountCtrl,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Monto'),
            ),
            const SizedBox(height: 16),

            // Descripción
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Descripción / Concepto'),
            ),
            const SizedBox(height: 16),

            // Campos dinámicos según el tipo de transacción
            if (_selectedType == TransactionType.loanTaken || _selectedType == TransactionType.loanGiven)
              Column(
                children: [
                  TextField(
                    controller: _counterpartyCtrl,
                    decoration: InputDecoration(
                      labelText: _selectedType == TransactionType.loanTaken
                          ? '¿Quién te prestó?'
                          : '¿A quién le prestaste?',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _interestCtrl,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Tasa de interés (%)'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _frequencyCtrl,
                    decoration: const InputDecoration(labelText: 'Frecuencia de pago (semana, quincena, mes)'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _numPaymentsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Número de pagos'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            ElevatedButton(
              onPressed: () {
                if (_selectedType == null || _amountCtrl.text.isEmpty) return;

                final newTx = TransactionModel(
                  id: DateTime.now().toIso8601String(),
                  type: _selectedType!,
                  amount: double.tryParse(_amountCtrl.text) ?? 0,
                  date: DateTime.now(),
                  description: _descCtrl.text,
                  counterparty: _counterpartyCtrl.text.isEmpty ? null : _counterpartyCtrl.text,
                  interestRate: double.tryParse(_interestCtrl.text),
                  frequency: _frequencyCtrl.text.isEmpty ? null : _frequencyCtrl.text,
                  numPayments: int.tryParse(_numPaymentsCtrl.text),
                  // Add more fields if needed
                );
                controller.addTransaction(newTx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Transacción agregada')),
                );
                _amountCtrl.clear();
                _descCtrl.clear();
                _counterpartyCtrl.clear();
                _interestCtrl.clear();
                _frequencyCtrl.clear();
                _numPaymentsCtrl.clear();
                setState(() {
                  _selectedType = null;
                });
              },
              child: const Text('Guardar'),
            ),
            const SizedBox(height: 32),

            // Balance
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Ingresos: \$${controller.totalIncome.toStringAsFixed(2)}'),
                    Text('Egresos: \$${controller.totalExpense.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
