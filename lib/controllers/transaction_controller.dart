// lib/controllers/transaction_controller.dart

import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransactionController with ChangeNotifier {
  final List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  void addTransaction(TransactionModel transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense || t.type == TransactionType.purchase || t.type == TransactionType.creditPurchase)
      .fold(0, (sum, t) => sum + t.amount);

  // Más getters para saldos por cuenta, tarjetas, etc., aquí
}
