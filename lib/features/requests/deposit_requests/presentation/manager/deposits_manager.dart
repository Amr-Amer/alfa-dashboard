import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';

abstract class DepositsManager {

  Future<void> fetchDepositsStream();

  Future<void> changeDepositStatus(
      TransactionModel transaction,
      String newStatus, {
        String? adminNote,
        required String userId,
        required String userToken,
        required Function(String) onError,
      });

  Future<void> sendStatusUpdateNotification({
    required String userId,
    required String userToken,
    required String status,
    required double amount,
    required String userName,
    required String note,
  });

  void searchDepositRequests(String query);

  void filterByStatus(String status);
}