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
  final List<StreamSubscription> _paymentsSubs = [];
  final List<TransactionModel> _debts = [];
  List<TransactionModel> get activeDebts =>
      _debts.where((d) => d.type == TransactionType.debt).toList();
  List<TransactionModel> get activeLoans =>
      _debts.where((d) => d.type == TransactionType.loan).toList();

  // Pagos individuales (toda la lista)
  final List<PaymentModel> _allPayments = [];
  List<PaymentModel> get allPayments => List.unmodifiable(_allPayments);

  StreamSubscription? _debtsSub;


  DebtController() {
    _listenDebts();
  }

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
      _listenAllPayments();
      notifyListeners();
    });
  }

  void _listenAllPayments() {
    for (var sub in _paymentsSubs) {
      sub.cancel();
    }
    _paymentsSubs.clear();
    _allPayments.clear();

    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

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
        _allPayments.removeWhere((p) => p.debtId == debt.id);
        _allPayments.addAll(
          snap.docs.map((d) => PaymentModel.fromJson(d.id, d.data())..debtId = debt.id),
        );
        notifyListeners();
      });
      _paymentsSubs.add(sub);
    }
  }

  Future<void> addDebt(TransactionModel d) async {
    _debts.insert(0, d);
    notifyListeners();

    try {
      final uid = _auth.currentUser!.uid;
      await _db
          .collection('users')
          .doc(uid)
          .collection('debts')
          .doc(d.id)
          .set(d.toJson());
    } catch (e) {
      _debts.removeWhere((deuda) => deuda.id == d.id);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateDebt(TransactionModel d) async {
    final uid = _auth.currentUser!.uid;
    await _db
        .collection('users')
        .doc(uid)
        .collection('debts')
        .doc(d.id)
        .update(d.toJson());
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

    final newPayment = PaymentModel(
      id: _db.collection('tmp').doc().id,
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
      final paymentRef = ref.collection('payments').doc(newPayment.id);
      tx.set(paymentRef, newPayment.toJson());
    });
  }

  Future<void> registerLoanPayment(String loanId, double amount, {String? comprobanteUrl}) async {
    await registerPayment(loanId, amount, comprobanteUrl: comprobanteUrl);
  }

  Future<void> updatePayment({
    required String debtId,
    required String paymentId,
    double? amount,
    String? comprobanteUrl,
  }) async {
    final uid = _auth.currentUser!.uid;
    final ref = _db
        .collection('users')
        .doc(uid)
        .collection('debts')
        .doc(debtId)
        .collection('payments')
        .doc(paymentId);

    final updateData = <String, dynamic>{};
    if (amount != null) updateData['amount'] = amount;
    if (comprobanteUrl != null) updateData['comprobanteUrl'] = comprobanteUrl;

    await ref.update(updateData);

    await recalculatePaidTotal(debtId);
  }

  Future<void> deletePayment(String debtId, String paymentId) async {
    final uid = _auth.currentUser!.uid;
    await _db
        .collection('users')
        .doc(uid)
        .collection('debts')
        .doc(debtId)
        .collection('payments')
        .doc(paymentId)
        .delete();

    await recalculatePaidTotal(debtId);
  }

  Future<void> recalculatePaidTotal(String debtId) async {
    final uid = _auth.currentUser!.uid;
    final paymentsSnap = await _db
        .collection('users')
        .doc(uid)
        .collection('debts')
        .doc(debtId)
        .collection('payments')
        .get();
    // Sumar todos los pagos para actualizar el total pagado
        final totalPaid = paymentsSnap.docs.fold<double>(
        0,
        (acc, doc) => acc + ((doc.data()['amount'] as num?)?.toDouble() ?? 0.0),
      );

// Actualizar el total pagado en la deuda
    await _db
        .collection('users')
        .doc(uid)
        .collection('debts')
        .doc(debtId)
        .update({'paid': totalPaid});
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
