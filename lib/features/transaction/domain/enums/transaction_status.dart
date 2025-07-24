enum TransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
}

extension TransactionStatusExt on TransactionStatus {
  String get name => toString().split('.').last;
  static TransactionStatus fromString(String value) {
    return TransactionStatus.values.firstWhere(
          (e) => e.name == value,
      orElse: () => TransactionStatus.pending,
    );
  }
}