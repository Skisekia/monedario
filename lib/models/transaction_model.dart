import 'enums.dart';

class TransactionModel {
  final String id;
  final TransactionType type;
  final AccountType accountType;
  final double amount;
  final DateTime date;
  final String? description;
  final String? counterparty;
  final double? interestRate;
  final String? frequency;
  final int? numPayments;

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
  });

  // Si usas Firestore, aquí van los métodos fromJson/toJson.
}
