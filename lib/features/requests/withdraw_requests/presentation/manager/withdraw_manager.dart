import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';

abstract class WithdrawManager {

  Future<void> fetchWithdrawsStream();

  Future<void> changeWithdrawStatus(
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

  void searchWithdrawRequests(String query);

  void filterByStatus(String status);
}