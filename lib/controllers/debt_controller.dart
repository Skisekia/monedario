import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction_model.dart';
import '../models/enums.dart';
import '../models/payment_model.dart';
import 'dart:async';

class DebtController extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // Deudas y préstamos
  final List<TransactionModel> _debts = [];
  List<TransactionModel> get activeDebts =>
      _debts.where((d) => d.type == TransactionType.debt).toList();
  List<TransactionModel> get activeLoans =>
      _debts.where((d) => d.type == TransactionType.loan).toList();

  // Pagos individuales (toda la lista)
  final List<PaymentModel> _allPayments = [];
  List<PaymentModel> get allPayments => List.unmodifiable(_allPayments);

  StreamSubscription? _debtsSub;
  List<StreamSubscription> _paymentsSubs = [];

  DebtController() {
    _listenDebts();
  }

  // --- Escucha la colección de deudas/préstamos ---
  void _listenDebts() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _debtsSub = _db
        .collection('users')
        .doc(uid)
        .collection('debts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snap) {
      _debts
        ..clear()
        ..addAll(snap.docs.map((d) => TransactionModel.fromJson(d.id, d.data())));
      // Cuando cambian las deudas, también cambiamos listeners de pagos
      _listenAllPayments();
      notifyListeners();
    });
  }

  // --- Escucha todas las subcolecciones 'payments' de cada deuda/préstamo ---
  void _listenAllPayments() {
    // Cancela listeners anteriores
    for (var sub in _paymentsSubs) {
      sub.cancel();
    }
    _paymentsSubs.clear();
    _allPayments.clear();

    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // Para cada deuda/préstamo, escucha sus pagos
    for (final debt in _debts) {
      final sub = _db
          .collection('users')
          .doc(uid)
          .collection('debts')
          .doc(debt.id)
          .collection('payments')
          .orderBy('date', descending: true)
          .snapshots()
          .listen((snap) {
        // Borra solo los pagos de esa deuda y agrégalos de nuevo
        _allPayments.removeWhere((p) => p.debtId == debt.id);
        _allPayments.addAll(
          snap.docs.map((d) => PaymentModel.fromJson(d.id, d.data())..debtId = debt.id),
        );
        notifyListeners();
      });
      _paymentsSubs.add(sub);
    }
  }

  // --- CRUD Deudas/Préstamos ---
  Future<void> addDebt(TransactionModel d) async {
    final uid = _auth.currentUser!.uid;
    await _db
        .collection('users')
        .doc(uid)
        .collection('debts')
        .doc(d.id)
        .set(d.toJson());
  }

  Future<void> deleteDebt(String debtId) async {
    final uid = _auth.currentUser!.uid;
    await _db
        .collection('users')
        .doc(uid)
        .collection('debts')
        .doc(debtId)
        .delete();
  }

  // --- Registrar y guardar un pago en la subcolección de la deuda/préstamo ---
  Future<void> registerPayment(
    String debtId,
    double amount, {
    String? comprobanteUrl,
  }) async {
    final uid = _auth.currentUser!.uid;
    final ref = _db
        .collection('users')
        .doc(uid)
        .collection('debts')
        .doc(debtId);

    // Crea un nuevo PaymentModel
    final newPayment = PaymentModel(
      id: _db.collection('tmp').doc().id, // genera un id aleatorio
      amount: amount,
      date: DateTime.now(),
      comprobanteUrl: comprobanteUrl,
      debtId: debtId,
    );

    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final prev = (snap['paid'] ?? 0).toDouble();
      final total = (prev + amount);

      final Map<String, dynamic> updateData = {'paid': total};
      if (comprobanteUrl != null) {
        updateData['comprobanteUrl'] = comprobanteUrl;
      }
      tx.update(ref, updateData);

      // Agrega el pago a la subcolección 'payments' de la deuda
      final paymentRef = ref.collection('payments').doc(newPayment.id);
      tx.set(paymentRef, newPayment.toJson());
    });
    // No es necesario llamar a fetch/refresh porque los listeners se actualizan solos
  }

  // Reutiliza registerPayment para préstamos
  Future<void> registerLoanPayment(String loanId, double amount, {String? comprobanteUrl}) async {
    await registerPayment(loanId, amount, comprobanteUrl: comprobanteUrl);
  }

  @override
  void dispose() {
    _debtsSub?.cancel();
    for (var sub in _paymentsSubs) {
      sub.cancel();
    }
    super.dispose();
  }
}
