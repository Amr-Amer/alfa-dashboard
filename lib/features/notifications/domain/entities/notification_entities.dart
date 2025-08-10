import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_type.dart';
import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String uid;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;
  final String? name;
  final String? status;
  final TransactionType? type;
  final Map<String, dynamic>? data;

  const NotificationEntity({
    required this.id,
    required this.uid,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
    this.name,
    this.status,
    this.type,
    this.data,
  });

  @override
  List<Object?> get props => [
    id,
    uid,
    title,
    body,
    createdAt,
    read,
    name,
    status,
    type,
    data,
  ];
}
