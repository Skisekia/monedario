import 'enums.dart';

class TransactionModel {
  final String id;
  final TransactionType type;      // ingreso, gasto, deuda, etc.
  final AccountType accountType;   // cash, card, credit…
  final double amount;
  final DateTime date;

  final String? description;
  final String? counterparty;
  final double? interestRate;
  final String? frequency;
  final int? numPayments;

  // ────────── NUEVOS CAMPOS ──────────
  double paid;     // monto ya abonado
  bool   isPaid;   // true cuando la deuda está liquidada

  TransactionModel({
    required this.id,
    required this.type,
    required this.accountType,
    required this.amount,
    required this.date,
    this.description,
    this.counterparty,
    this.interestRate,
    this.frequency,
    this.numPayments,

    // nuevos con valores por defecto
    this.paid = 0,
    this.isPaid = false,
  });

  // Monto restante (útil para vistas y forms)
  double get remaining => amount - paid;
}
