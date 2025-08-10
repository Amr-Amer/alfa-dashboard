import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/features/notifications/domain/entities/notification_entities.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.uid,
    required super.title,
    required super.body,
    required super.createdAt,
    super.read,
    super.name,
    super.type,
    super.status,
    super.data,
  });

  NotificationModel copyWith({
    String? id,
    String? uid,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? read,
    String? name,
    TransactionType? type,
    String? status,
    Map<String, dynamic>? data,
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
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map[FirebaseConstants.notificationId] as String,
      uid: map[FirebaseConstants.notificationUid] as String,
      title: map[FirebaseConstants.notificationTitle] as String,
      body: map[FirebaseConstants.notificationBody] as String,
      createdAt: (map[FirebaseConstants.createdAt] as Timestamp).toDate(),
      read: map[FirebaseConstants.notificationRead] as bool? ?? false,
      name: map[FirebaseConstants.userName] as String?,
      status: map[FirebaseConstants.notificationStatus] as String?,
      type: TransactionTypeExt.fromString(
        map[FirebaseConstants.notificationType] ?? FirebaseConstants.deposit,
      ),
      data: map[FirebaseConstants.data] != null
          ? Map<String, dynamic>.from(map[FirebaseConstants.data])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirebaseConstants.notificationId: id,
      FirebaseConstants.notificationUid: uid,
      FirebaseConstants.notificationTitle: title,
      FirebaseConstants.notificationBody: body,
      FirebaseConstants.createdAt: Timestamp.fromDate(createdAt),
      FirebaseConstants.notificationRead: read,
      FirebaseConstants.userName: name,
      FirebaseConstants.notificationType: type?.name,
      FirebaseConstants.notificationStatus: status,
      FirebaseConstants.notificationData: data,
    };
  }
}
