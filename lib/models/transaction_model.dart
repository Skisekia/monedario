// 📄 lib/models/transaction_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';   // Importa tus enums personalizados

class TransactionModel {
  final String          id; // ID de la transacción
  final String          concept; // concepto de la transacción
  final double          amount; // monto de la transacción
  final double          paid; // monto ya pagado
  final String          owner;        // a quién le debo
  final DateTime        dueDate; // fecha de vencimiento de la deuda
  final PaymentFreq     frequency;    // mensual / quincenal / semanal
  final int             numPayments; // número de pagos esperados
  final TransactionType type;         // debt / payment …
  final AccountType     accountType; // cuenta corriente / tarjeta de crédito / efectivo
  final DateTime        createdAt; // fecha de creación de la transacción
  final DateTime        date; // fecha de la transacción
 
// Constructor para crear una instancia de TransactionModel
  TransactionModel({
    required this.id, // ID de la transacción
    required this.concept, // concepto de la transacción
    required this.amount, // monto de la transacción
    required this.paid, // monto ya pagado
    required this.owner, // a quién le debo
    required this.dueDate, // fecha de vencimiento de la deuda
    required this.frequency, // frecuencia de pago
    required this.numPayments, // número de pagos esperados
    required this.type, // tipo de transacción (deuda, pago, etc.)
    required this.accountType, // cuenta corriente / tarjeta de crédito / efectivo
    required this.createdAt, // fecha de creación de la transacción
    required this.date, // fecha de la transacción
    
  });

  // Convierte la instancia a Map (para guardar en Firestore/JSON)
  Map<String, dynamic> toJson() => {
        'concept'      : concept,  // concepto de la transacción
        'amount'       : amount, // monto de la transacción
        'paid'         : paid, // monto ya pagado
        'owner'        : owner, // a quién le debo
        'dueDate'      : Timestamp.fromDate(dueDate), // fecha de vencimiento de la deuda
        'frequency'    : frequency.name, // frecuencia de pago
        'numPayments'  : numPayments, // número de pagos esperados
        'type'         : type.name, // tipo de transacción (deuda, pago, etc.)
        'accountType'  : accountType.name, // cuenta corriente / tarjeta de crédito / efectivo
        'createdAt'    : Timestamp.fromDate(createdAt), // fecha de creación de la transacción
        'date'         : Timestamp.fromDate(date), // fecha de la transacción
      };
 // Crea una instancia de TransactionModel desde un Map (Firestore/JSON)
  // Si no se proporciona un valor, se usa un valor por defecto
  factory TransactionModel.fromJson(String id, Map<String, dynamic> json) {
    DateTime _fromTs(dynamic v) => v is Timestamp ? v.toDate() : DateTime.now();

    return TransactionModel(
      id          : id, // ID de la transacción
      concept     : json['concept']        as String, // concepto de la transacción
      // Convierte los valores numéricos a double, si no existen usa 0.
      amount      : (json['amount'] ?? 0).toDouble(), // monto de la transacción
      paid        : (json['paid']   ?? 0).toDouble(), // monto ya pagado
      owner       : json['owner']          as String, // a quién le debo
      dueDate     : (json['dueDate'] as Timestamp).toDate(), // fecha de vencimiento de la deuda
      frequency   : PaymentFreq.values.byName(json['frequency']), // frecuencia de pago
      numPayments : json['numPayments']    as int, // número de pagos esperados
      type        : TransactionType.values.byName(json['type']), // tipo de transacción
      accountType : AccountType.values.byName(json['accountType']), // tipo de cuenta
      createdAt   : (json['createdAt'] as Timestamp).toDate(), // fecha de creación
      date        : _fromTs(json['date']), // fecha de la transacción

    );
  }
  // Método para actualizar el monto pagado
  // Retorna una nueva instancia con el monto pagado actualizado
  TransactionModel copyWith({double? paid}) => TransactionModel(
        id          : id, // ID de la transacción
        concept     : concept, // concepto de la transacción
        amount      : amount, // monto de la transacción
        paid        : paid ?? this.paid, // monto ya pagado
        owner       : owner, // a quién le debo
        dueDate     : dueDate, // fecha de vencimiento de la deuda
        frequency   : frequency, // frecuencia de pago
        numPayments : numPayments, // número de pagos esperados
        type        : type, // tipo de transacción
        accountType : accountType, // tipo de cuenta
        createdAt   : createdAt, // fecha de creación
        date        : date, // fecha de la transacción
      );
}
