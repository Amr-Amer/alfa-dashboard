enum TransactionType { deposit, withdraw }

extension TransactionTypeExt on TransactionType {
  String get name => toString().split('.').last;
  static TransactionType fromString(String value) {
    return TransactionType.values.firstWhere(
          (e) => e.name == value,
      orElse: () => TransactionType.deposit,
    );
  }
}