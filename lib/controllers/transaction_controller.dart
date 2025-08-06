import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../models/enums.dart';

class TransactionController extends ChangeNotifier {
  final List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  /* CRUD */
  void addTransaction(TransactionModel tx) {
    _transactions.add(tx);
    notifyListeners();
  }

  void removeTransaction(String id) {
    _transactions.removeWhere((tx) => tx.id == id);
    notifyListeners();
  }

  /* Totales */
  double get totalIncome => _transactions
      .where((tx) =>
          tx.type == TransactionType.income ||
          (tx.type == TransactionType.transfer && tx.amount > 0))
      .fold(0.0, (sum, tx) => sum + tx.amount);

  double get totalExpense => _transactions
      .where((tx) =>
          tx.type == TransactionType.expense ||
          (tx.type == TransactionType.transfer && tx.amount < 0))
      .fold(
        0.0,
        (sum, tx) => sum + (tx.amount < 0 ? -tx.amount : tx.amount),
      );

  double getTotalByAccountType(AccountType type) => _transactions
      .where((tx) => tx.accountType == type)
      .fold(0.0, (sum, tx) => sum + tx.amount);

  /* Próximos vencimientos */
  List<TransactionModel> getUpcomingTransactions() {
    final now = DateTime.now();
    return _transactions
        .where((tx) => tx.dueDate.isAfter(now))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }
}
