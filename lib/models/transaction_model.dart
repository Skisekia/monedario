// lib/models/transaction_model.dart

enum TransactionType {
  income,
  expense,
  loanTaken,    // Préstamo solicitado
  loanGiven,    // Préstamo otorgado
  purchase,
  creditPurchase,
  payment,
  transfer,
}

class TransactionModel {
  String id;
  TransactionType type;
  double amount;
  DateTime date;
  String description;
  // Para préstamos
  String? counterparty;  // Persona o entidad
  double? interestRate;
  String? frequency;     // semana, quincena, mes
  int? numPayments;
  double? remainingAmount;
  // Para transferencias
  String? fromAccount;
  String? toAccount;
  // Etiquetas
  String? userTag;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
    this.counterparty,
    this.interestRate,
    this.frequency,
    this.numPayments,
    this.remainingAmount,
    this.fromAccount,
    this.toAccount,
    this.userTag,
  });
}
