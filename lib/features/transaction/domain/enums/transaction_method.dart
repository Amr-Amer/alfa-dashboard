enum TransactionMethod {
  cash,
  bankTransfer,
  visa,
  mastercard,
  wallet,
}

extension TransactionMethodExt on TransactionMethod {
  String get name => toString().split('.').last;
  static TransactionMethod fromString(String value) {
    return TransactionMethod.values.firstWhere(
          (e) => e.name == value,
      orElse: () => TransactionMethod.cash,
    );
  }
}