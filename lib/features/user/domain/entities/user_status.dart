enum UserStatus { active, inactive }

extension UserStatusExtension on UserStatus {
  String get name => toString().split('.').last;
  static UserStatus fromString(String value) {
    return UserStatus.values.firstWhere(
          (e) => e.name == value,
      orElse: () => UserStatus.active,
    );
  }
}