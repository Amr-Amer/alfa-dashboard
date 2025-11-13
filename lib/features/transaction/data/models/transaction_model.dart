import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/features/transaction/domain/entities/transaction_entities.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_method.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_status.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.amount,
    required super.commission,
    required super.currency,
    required super.method,
    required super.note,
    required super.status,
    required super.type,
    required super.uid,
    required super.userName,
    required super.bankTransactionId,
    required super.createdAt,
    required super.updatedAt,
    required super.adminNote,
    required super.userToken,
    required super.receiptUrl
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map[FirebaseConstants.transId] ?? '',
      amount: (map[FirebaseConstants.amount] ?? 0).toDouble(),
      commission: (map[FirebaseConstants.commission] ?? 0).toDouble(),
      currency: map[FirebaseConstants.currency] ?? '',
      method: TransactionMethodExt.fromString(map[FirebaseConstants.method] ?? FirebaseConstants.visa),
      note: map[FirebaseConstants.note] ?? '',
      status: TransactionStatusExt.fromString(map[FirebaseConstants.status] ?? FirebaseConstants.pending),
      type: TransactionTypeExt.fromString(map[FirebaseConstants.type] ?? FirebaseConstants.deposit),
      uid: map[FirebaseConstants.uId] ?? '',
      userName: map[FirebaseConstants.userName] ?? '',
      bankTransactionId: map[FirebaseConstants.bankTransactionId] ?? '',
      createdAt: (map[FirebaseConstants.createdAt] as Timestamp).toDate(),
      updatedAt: (map[FirebaseConstants.updatedAt] as Timestamp).toDate(),
      adminNote: map[FirebaseConstants.adminNote] ?? '',
      userToken: map[FirebaseConstants.fcmToken] ?? '',
      receiptUrl: map[FirebaseConstants.receiptUrl] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirebaseConstants.transId: id,
      FirebaseConstants.amount: amount,
      FirebaseConstants.commission: commission,
      FirebaseConstants.currency: currency,
      FirebaseConstants.method: method.name,
      FirebaseConstants.note : note,
      FirebaseConstants.status: status.name,
      FirebaseConstants.type: type.name,
      FirebaseConstants.uId: uid,
      FirebaseConstants.userName: userName,
      FirebaseConstants.bankTransactionId : bankTransactionId,
      FirebaseConstants.createdAt: Timestamp.fromDate(createdAt),
      FirebaseConstants.updatedAt: Timestamp.fromDate(updatedAt),
      FirebaseConstants.adminNote : adminNote,
      FirebaseConstants.fcmToken : userToken,
      FirebaseConstants.receiptUrl : receiptUrl
    };
  }

  TransactionModel copyWith({
    String? id,
    double? amount,
    double? commission,
    String? currency,
    TransactionMethod? method,
    String? note,
    TransactionStatus? status,
    TransactionType? type,
    String? uid,
    String? userName,
    String? bankTransactionId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? adminNote,
    String? userToken,
    String? receiptUrl
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      commission: commission ?? this.commission,
      currency: currency ?? this.currency,
      method: method ?? this.method,
      note: note ?? this.note,
      status: status ?? this.status,
      type: type ?? this.type,
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      bankTransactionId: bankTransactionId ?? this.bankTransactionId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      adminNote: adminNote ?? this.adminNote,
      userToken: userToken ?? this.userToken,
      receiptUrl: receiptUrl ?? this.receiptUrl
    );
  }

  factory TransactionModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data()!;
    return TransactionModel(
      id: doc.id,
      amount: (data[FirebaseConstants.amount] ?? 0).toDouble(),
      commission: (data[FirebaseConstants.commission] ?? 0).toDouble(),
      currency: data[FirebaseConstants.currency] ?? '',
      method: TransactionMethodExt.fromString(
          data[FirebaseConstants.method] ?? FirebaseConstants.visa),
      note: data[FirebaseConstants.note] ?? '',
      status: TransactionStatusExt.fromString(
          data[FirebaseConstants.status] ?? FirebaseConstants.pending),
      type: TransactionTypeExt.fromString(
          data[FirebaseConstants.type] ?? FirebaseConstants.deposit),
      uid: data[FirebaseConstants.uId] ?? '',
      userName: data[FirebaseConstants.userName] ?? '',
      bankTransactionId: data[FirebaseConstants.bankTransactionId] ?? '',
      createdAt: (data[FirebaseConstants.createdAt] as Timestamp).toDate(),
      updatedAt: (data[FirebaseConstants.updatedAt] as Timestamp).toDate(),
      adminNote: data[FirebaseConstants.adminNote] ?? '',
      userToken: data[FirebaseConstants.fcmToken] ?? '',
      receiptUrl: data[FirebaseConstants.receiptUrl] ?? '',
    );
  }
}
