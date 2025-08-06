// 📄 lib/models/transaction_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

class TransactionModel {
  final String          id;
  final String          concept;
  final double          amount;
  final double          paid;
  final String          owner;        // a quién le debo
  final DateTime        dueDate;
  final PaymentFreq     frequency;    // mensual / quincenal / semanal
  final int             numPayments;
  final TransactionType type;         // debt / payment …
  final AccountType     accountType;
  final DateTime        createdAt;

  TransactionModel({
    required this.id,
    required this.concept,
    required this.amount,
    required this.paid,
    required this.owner,
    required this.dueDate,
    required this.frequency,
    required this.numPayments,
    required this.type,
    required this.accountType,
    required this.createdAt,
  });

  /*------------ mapeo Firestore ------------*/
  Map<String, dynamic> toJson() => {
        'concept'      : concept,
        'amount'       : amount,
        'paid'         : paid,
        'owner'        : owner,
        'dueDate'      : Timestamp.fromDate(dueDate),
        'frequency'    : frequency.name,
        'numPayments'  : numPayments,
        'type'         : type.name,
        'accountType'  : accountType.name,
        'createdAt'    : Timestamp.fromDate(createdAt),
      };

  factory TransactionModel.fromJson(String id, Map<String, dynamic> json) {
    return TransactionModel(
      id          : id,
      concept     : json['concept']        as String,
      amount      : (json['amount'] ?? 0).toDouble(),
      paid        : (json['paid']   ?? 0).toDouble(),
      owner       : json['owner']          as String,
      dueDate     : (json['dueDate'] as Timestamp).toDate(),
      frequency   : PaymentFreq.values.byName(json['frequency']),
      numPayments : json['numPayments']    as int,
      type        : TransactionType.values.byName(json['type']),
      accountType : AccountType.values.byName(json['accountType']),
      createdAt   : (json['createdAt'] as Timestamp).toDate(),
    );
  }

  TransactionModel copyWith({double? paid}) => TransactionModel(
        id          : id,
        concept     : concept,
        amount      : amount,
        paid        : paid ?? this.paid,
        owner       : owner,
        dueDate     : dueDate,
        frequency   : frequency,
        numPayments : numPayments,
        type        : type,
        accountType : accountType,
        createdAt   : createdAt,
      );
}

/* enums extra */
enum PaymentFreq { mensual, quincenal, semanal }
