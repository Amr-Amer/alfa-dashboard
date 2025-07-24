import 'package:alfa_dashboard/features/user/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alfa_dashboard/core/networking/firebase_constants.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.displayName,
    super.photoURL,
    required super.emailVerified,
    required super.phoneNumber,
    super.address,
    required super.balance,
    super.totalEarnings,
    super.currency,
    super.createdAt,
    super.updatedAt,
    super.languageCode,
    super.notificationsEnabled = true,
    super.isActive = true,
    super.isAdmin = false,
  });

  /// ✅ From Firebase Auth
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
      phoneNumber: user.phoneNumber ?? '',
      address: '',
      balance: 0.0,
      totalEarnings: 0.0,
      currency: 'EGP',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      languageCode: 'ar',
      notificationsEnabled: true,
      isActive: true,
      isAdmin: false,
    );
  }

  /// ✅ From Firestore
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data[FirebaseConstants.uId] ?? '',
      email: data[FirebaseConstants.email] ?? '',
      displayName: data[FirebaseConstants.displayName] ?? '',
      photoURL: data[FirebaseConstants.photoURL],
      emailVerified: data[FirebaseConstants.emailVerified] ?? false,
      phoneNumber: data[FirebaseConstants.phoneNumber] ?? '',
      address: data[FirebaseConstants.address],
      balance: (data[FirebaseConstants.balance] as num?)?.toDouble() ?? 0.0,
      totalEarnings: (data[FirebaseConstants.totalEarnings] as num?)?.toDouble(),
      currency: data[FirebaseConstants.currency] ?? 'EGP',
      createdAt: (data[FirebaseConstants.createdAt] as Timestamp?)?.toDate(),
      updatedAt: (data[FirebaseConstants.updatedAt] as Timestamp?)?.toDate(),
      languageCode: data[FirebaseConstants.languageCode],
      notificationsEnabled: data[FirebaseConstants.notificationsEnabled] ?? true,
      isActive: data[FirebaseConstants.isActive] ?? true,
      isAdmin: data[FirebaseConstants.isAdmin] ?? false,
    );
  }

  /// ✅ To Firestore
  Map<String, dynamic> toMap() {
    return {
      FirebaseConstants.uId: uid,
      FirebaseConstants.email: email,
      FirebaseConstants.displayName: displayName,
      FirebaseConstants.photoURL: photoURL,
      FirebaseConstants.emailVerified: emailVerified,
      FirebaseConstants.phoneNumber: phoneNumber,
      FirebaseConstants.address: address,
      FirebaseConstants.balance: balance,
      FirebaseConstants.totalEarnings: totalEarnings,
      FirebaseConstants.currency: currency,
      FirebaseConstants.createdAt: createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      FirebaseConstants.updatedAt: updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      FirebaseConstants.languageCode: languageCode,
      FirebaseConstants.notificationsEnabled: notificationsEnabled,
      FirebaseConstants.isActive: isActive,
      FirebaseConstants.isAdmin: isAdmin,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? emailVerified,
    String? phoneNumber,
    String? address,
    double? balance,
    double? totalEarnings,
    String? currency,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? languageCode,
    bool? notificationsEnabled,
    bool? isActive,
    bool? isAdmin,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      balance: balance ?? this.balance,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      languageCode: languageCode ?? this.languageCode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isActive: isActive ?? this.isActive,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  /// ✅ Convert back to Entity if needed
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      emailVerified: emailVerified,
      phoneNumber: phoneNumber,
      address: address,
      balance: balance,
      totalEarnings: totalEarnings,
      currency: currency,
      createdAt: createdAt,
      updatedAt: updatedAt,
      languageCode: languageCode,
      notificationsEnabled: notificationsEnabled,
      isActive: isActive,
      isAdmin: isAdmin,
    );
  }
}
