import 'package:alfa_dashboard/features/user/domain/entities/user_status.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final bool emailVerified;
  final String phoneNumber;
  final String? address;
  final double balance;
  final double? totalEarnings;
  final String? currency;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? languageCode;
  final bool notificationsEnabled;
  final bool isAdmin;
  final UserStatus status;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    required this.emailVerified,
    required this.phoneNumber,
    this.address,
    required this.balance,
    this.totalEarnings,
    this.currency,
    this.createdAt,
    this.updatedAt,
    this.languageCode = 'ar',
    this.notificationsEnabled = true,
    this.isAdmin = false,
    required this.status,
  });

  @override
  List<Object?> get props => [uid, email, displayName, photoURL, emailVerified, phoneNumber, address, balance, totalEarnings, currency, createdAt, updatedAt, languageCode, notificationsEnabled, isAdmin, status];
}