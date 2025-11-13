import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_status.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String uid;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;
  final String? name;
  final TransactionStatus? status;
  final TransactionType? type;
  final String? transId;
  final double? amount;
  final String? adminNote;
  final String? fcmToken;


  const NotificationModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
    this.name,
    this.type,
    // this.data,
    this.status,
    this.transId,
    this.amount,
    this.adminNote,
    this.fcmToken,
  });

  // Manual copyWith method
  NotificationModel copyWith({
    String? id,
    String? uid,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? read,
    String? name,
    TransactionType? type,
    TransactionStatus? status,
    String? transId,
    double? amount,
    String? adminNote,
    String? fcmToken,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      read: read ?? this.read,
      name: name ?? this.name,
      type: type ?? this.type,
      // data: data ?? this.data,
      status: status ?? this.status,
      transId: transId ?? this.transId,
      amount: amount ?? this.amount,
      adminNote: adminNote ?? this.adminNote,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map[FirebaseConstants.id] as String? ?? map['id'] ?? '',
      uid: map[FirebaseConstants.notificationUid] as String,
      title: map[FirebaseConstants.notificationTitle] as String,
      body: map[FirebaseConstants.notificationBody] as String,
      createdAt: (map[FirebaseConstants.createdAt] as Timestamp).toDate(),
      read: map[FirebaseConstants.notificationRead] as bool? ?? false,
      name: map[FirebaseConstants.userName] as String?,
      status: TransactionStatusExt.fromString(map[FirebaseConstants.status] ?? FirebaseConstants.pending),
      type: TransactionTypeExt.fromString(map[FirebaseConstants.type] ?? FirebaseConstants.deposit),
      transId: map[FirebaseConstants.transId] as String?,
      amount: map[FirebaseConstants.amount] as double?,
      adminNote: map[FirebaseConstants.adminNote] as String?,
      fcmToken: map[FirebaseConstants.fcmToken] as String?,
      // data: map[FirebaseConstants.data] != null ? Map<String, dynamic>.from(map[FirebaseConstants.data]) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirebaseConstants.id: id,
      FirebaseConstants.notificationUid: uid,
      FirebaseConstants.notificationTitle: title,
      FirebaseConstants.notificationBody: body,
      FirebaseConstants.createdAt: Timestamp.fromDate(createdAt),
      FirebaseConstants.notificationRead: read,
      FirebaseConstants.userName: name,
      FirebaseConstants.type: type?.name,
      FirebaseConstants.status: status?.name,
      FirebaseConstants.transId: transId,
      FirebaseConstants.amount: amount,
      FirebaseConstants.adminNote: adminNote,
      FirebaseConstants.fcmToken: fcmToken,
      // FirebaseConstants.data : data,
    };
  }
}
