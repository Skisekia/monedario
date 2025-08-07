enum AccountType {
  cash,
  card,
  credit,
  loan,
  debt,
  personal
}

enum TransactionType {
  income,
  expense,
  transfer,
  loanGiven,
  loanTaken,
  payment,
  debt,
  loan
}

// Frecuencia con la que se repite un pago/deuda.
enum PaymentFreq { diaria, semanal, quincenal, mensual, anual }

// Etiquetas para los tipos de transacción.
extension PaymentFreqExt on PaymentFreq {
  String get label {
    switch (this) {
      case PaymentFreq.diaria:     return 'Diaria';
      case PaymentFreq.semanal:    return 'Semanal';
      case PaymentFreq.quincenal:  return 'Quincenal';
      case PaymentFreq.mensual:    return 'Mensual';
      case PaymentFreq.anual:      return 'Anual';
    }
  }
}
