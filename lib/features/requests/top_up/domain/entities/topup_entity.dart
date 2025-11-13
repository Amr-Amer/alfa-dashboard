import 'package:alfa_dashboard/features/requests/top_up/domain/enums/topup_status.dart';
import 'package:alfa_dashboard/features/requests/top_up/domain/enums/transfer_channel.dart';
import 'package:equatable/equatable.dart';

class TopUpEntity extends Equatable {
  final String topUpId;
  final String userId;
  final TransferChannel channel;
  final double amount;
  final String? transferRef;
  final DateTime transferAt;
  final String receiptUrl;
  final TopUpStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TopUpEntity({
    required this.topUpId,
    required this.userId,
    required this.channel,
    required this.amount,
    this.transferRef,
    required this.transferAt,
    required this.receiptUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        topUpId,
        userId,
        channel,
        amount,
        transferRef,
        transferAt,
        receiptUrl,
        status,
        createdAt,
        updatedAt,
      ];
}
