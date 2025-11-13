enum TopUpStatus {
  pending,
  approved,
  rejected,
}

extension TopupStatusExt on TopUpStatus {
  String get name => toString().split('.').last;

  static TopUpStatus fromString(String value) {
    return TopUpStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TopUpStatus.pending,
    );
  }
}
