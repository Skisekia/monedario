import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String id;
  final double amount;
  final DateTime date;
  final String? comprobanteUrl;
  String? debtId; // <-- Campo para saber a qué deuda/préstamo pertenece

  PaymentModel({
    required this.id,
    required this.amount,
    required this.date,
    this.comprobanteUrl,
    this.debtId,
  });

  factory PaymentModel.fromJson(String id, Map<String, dynamic> json) {
    // Manejo seguro de date
    DateTime dateObj;
    if (json['date'] is Timestamp) {
      dateObj = (json['date'] as Timestamp).toDate();
    } else if (json['date'] is DateTime) {
      dateObj = json['date'];
    } else if (json['date'] is String) {
      dateObj = DateTime.tryParse(json['date']) ?? DateTime.now();
    } else {
      dateObj = DateTime.now();
    }

    return PaymentModel(
      id: id,
      amount: (json['amount'] ?? 0).toDouble(),
      date: dateObj,
      comprobanteUrl: json['comprobanteUrl'],
      debtId: json['debtId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'date': Timestamp.fromDate(date),
        'comprobanteUrl': comprobanteUrl,
        if (debtId != null) 'debtId': debtId,
      };
}
