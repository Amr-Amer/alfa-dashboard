import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/features/requests/top_up/domain/entities/topup_entity.dart';
import 'package:alfa_dashboard/features/requests/top_up/domain/enums/topup_status.dart';
import 'package:alfa_dashboard/features/requests/top_up/domain/enums/transfer_channel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TopUpModel extends TopUpEntity {
  const TopUpModel({
    required super.topUpId,
    required super.userId,
    required super.channel,
    required super.amount,
    super.transferRef,
    required super.transferAt,
    required super.receiptUrl,
    required super.status,
    required super.createdAt,
    required super.updatedAt,

  });

  factory TopUpModel.fromMap(Map<String, dynamic> map) {
    return TopUpModel(
      topUpId: map[FirebaseConstants.topUpId] ?? '',
      userId: map[FirebaseConstants.userId] ?? '',
      channel: TransferChannelExt.fromString(map[FirebaseConstants.channel] ?? TransferChannel.bank),
      amount: (map[FirebaseConstants.amount] ?? 0).toDouble(),
      transferRef: map[FirebaseConstants.transferRef],
      transferAt: (map[FirebaseConstants.transferAt] as Timestamp).toDate(),
      receiptUrl: map[FirebaseConstants.receiptUrl] ?? '',
      status: TopupStatusExt.fromString(map[FirebaseConstants.status] ?? TopUpStatus.pending),
      createdAt: (map[FirebaseConstants.createdAt] as Timestamp).toDate(),
      updatedAt: (map[FirebaseConstants.updatedAt] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirebaseConstants.topUpId : topUpId,
      FirebaseConstants.userId : userId,
      FirebaseConstants.channel : channel.channelValue,
      FirebaseConstants.amount : amount,
      FirebaseConstants.transferRef : transferRef,
      FirebaseConstants.transferAt : Timestamp.fromDate(transferAt),
      FirebaseConstants.receiptUrl : receiptUrl,
      FirebaseConstants.status : status.name,
      FirebaseConstants.createdAt : Timestamp.fromDate(createdAt),
      FirebaseConstants.updatedAt : Timestamp.fromDate(updatedAt),
    };
  }

  TopUpModel copyWith({
    String? topUpId,
    String? userId,
    TransferChannel? channel,
    double? amount,
    String? transferRef,
    DateTime? transferAt,
    String? receiptUrl,
    TopUpStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TopUpModel(
      topUpId: topUpId ?? this.topUpId,
      userId: userId ?? this.userId,
      channel: channel ?? this.channel,
      amount: amount ?? this.amount,
      transferRef: transferRef ?? this.transferRef,
      transferAt: transferAt ?? this.transferAt,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
