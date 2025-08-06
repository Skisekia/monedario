// 📄 lib/controllers/debt_controller.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction_model.dart';
import 'dart:async';

class DebtController extends ChangeNotifier {
  final _auth  = FirebaseAuth.instance;
  final _db    = FirebaseFirestore.instance;

  /*–––––––– STREAM EN MEMORIA ––––––––*/
  final List<TransactionModel> _debts = [];
  List<TransactionModel> get activeDebts => List.unmodifiable(_debts);

  StreamSubscription? _sub;        

  DebtController() {
    _listenDebts();
  }

  void _listenDebts() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _sub = _db.collection('users')
        .doc(uid)
        .collection('debts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snap) {
      _debts
        ..clear()
        ..addAll(snap.docs.map((d) => TransactionModel.fromJson(d.id, d.data())));
      notifyListeners();
    });
  }

  /*–––––––– CRUD ––––––––*/
  Future<void> addDebt(TransactionModel d) async {
    final uid = _auth.currentUser!.uid;
    await _db
        .collection('users')
        .doc(uid)
        .collection('debts')
        .doc(d.id)
        .set(d.toJson());
  }

  Future<void> registerPayment(String debtId, double amount) async {
    final uid = _auth.currentUser!.uid;
    final ref = _db
        .collection('users')
        .doc(uid)
        .collection('debts')
        .doc(debtId);

    await _db.runTransaction((tx) async {
      final snap  = await tx.get(ref);
      final prev  = (snap['paid'] ?? 0).toDouble();
      final total = (prev + amount);

      tx.update(ref, {'paid': total});
    });
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

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
