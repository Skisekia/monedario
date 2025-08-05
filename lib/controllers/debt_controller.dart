import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

/// Controlador en memoria (ChangeNotifier).
/// Sustituye la lista interna por Firestore/SQLite cuando lo necesites.
class DebtController extends ChangeNotifier {
  final List<TransactionModel> _debts = [];

  /// Deudas aún activas (no pagadas).
  List<TransactionModel> get activeDebts =>
      _debts.where((d) => !d.isPaid).toList();

  /// Todas las deudas, pagadas o no.
  List<TransactionModel> get allDebts => List.unmodifiable(_debts);

  // --------------------- CRUD ----------------------------------------------
  Future<void> addDebt(TransactionModel d) async {
    _debts.add(d);
    notifyListeners();
    // TODO: Persistir en base de datos
  }

  Future<void> addPayment(String debtId, double amount) async {
    final debt = _debts.firstWhere((d) => d.id == debtId);
    debt.paid += amount;
    if (debt.paid >= debt.amount) debt.isPaid = true;
    notifyListeners();
    // TODO: Actualizar en base de datos
  }

  Future<void> deleteDebt(String id) async {
    _debts.removeWhere((d) => d.id == id);
    notifyListeners();
    // TODO: Eliminar en base de datos
  }
}
