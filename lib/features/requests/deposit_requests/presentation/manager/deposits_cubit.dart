import 'dart:async';
import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/notifications/data/models/notification_model.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/send_notification_usecase.dart';
import 'package:alfa_dashboard/features/notifications/presentation/services/send_notification_services.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/domain/usecases/fetch_deposits_stream_usecase.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/domain/usecases/update_deposits_status_usecase.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/presentation/manager/deposits_manager.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_status.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_type.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_cubit.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
part 'deposits_state.dart';

class DepositsCubit extends Cubit<DepositsState> implements DepositsManager {
  final FetchDepositsStreamUseCase _depositsStreamUseCase;
  final UpdateDepositsStatusUseCase _updateDepositsUseCase;
  final SendNotificationUseCase _sendNotificationUseCase;
  final UserCubit _userCubit;

  DepositsCubit(
      this._depositsStreamUseCase,
      this._updateDepositsUseCase,
      this._userCubit,
      this._sendNotificationUseCase,
      ) : super(DepositsInitial()) {
    fetchDepositsStream();
  }

  StreamSubscription? _depositStreamSubscription;
  String selectedStatus = 'all';

  @override
  Future<void> close() {
    _depositStreamSubscription?.cancel();
    return super.close();
  }

  @override
  Future<void> fetchDepositsStream() async {
    emit(DepositsLoading());
    _depositStreamSubscription?.cancel();
    _depositStreamSubscription = _depositsStreamUseCase().listen(
          (either) {
        either.fold(
              (failure) => emit(DepositsError(failure.message)),
              (result) {
            depositRequestsList = result;
            emit(DepositsLoaded(depositRequests));
            if (kDebugMode) {
              print("depositRequests data.................... ${depositRequests.length}");
            }
          },
        );
      },
    );
  }

  @override
  Future<void> changeDepositStatus(
      TransactionModel transaction,
      String newStatus, {
        String? adminNote,
        required String userId,
        required String userToken,
        required Function(String) onError,
      }) async {
    try {
      emit(DepositsUpdating());

      final updated = transaction.copyWith(
        status: TransactionStatusExt.fromString(newStatus),
        adminNote: adminNote ?? transaction.adminNote,
        updatedAt: DateTime.now(),
      );

      final result = await _updateDepositsUseCase.call(updated);

      result.fold(
            (failure) {
          emit(DepositsError(failure.message));
          onError(failure.message);
        },
            (_) async {
          if (newStatus == TransactionStatus.completed.name) {
            await _userCubit.updateUserBalance(transaction.amount, userId);
          }

          await sendStatusUpdateNotification(
            userId: userId,
            userToken: userToken,
            status: newStatus,
            amount: transaction.amount,
            userName: transaction.userName,
            note: adminNote ?? transaction.adminNote,
          );

          await fetchDepositsStream();
          emit(DepositsLoaded(depositRequests));
        },
      );
    } catch (e) {
      const errorMsg = AppStrings.updateStatusError;
      emit(DepositsError(errorMsg));
      onError(errorMsg);
    }
  }

  @override
  Future<void> sendStatusUpdateNotification({
    required String userId,
    required String userToken,
    required String status,
    required double amount,
    required String userName,
    required String note,
  }) async {
    final statusText = GlobalFun.getStatusAr(TransactionStatusExt.fromString(status));
    final title = AppStrings.updateDepositStatus;

    String body;
    if (status == TransactionStatus.completed.name) {
      body = 'تم إضافة مبلغ $amount إلى رصيدك بنجاح';
    } else {
      final finalNote = note.trim().isEmpty ? AppStrings.noNoteAdded : note;
      body = '$statusText\n$finalNote';
    }

    final notification = NotificationModel(
      id: GlobalFun.generateId(),
      uid: userId,
      title: title,
      body: body,
      createdAt: DateTime.now(),
      read: false,
      amount: amount,
      status: TransactionStatusExt.fromString(status),
      type: TransactionType.deposit,
      fcmToken: userToken,
      name: userName,
      adminNote: note,
    );

    final result = await _sendNotificationUseCase.call(notification);

    result.fold(
          (error) => emit(DepositsError(error.message)),
          (_) async {
        await sendNotification(
          token: userToken,
          title: title,
          body: body,
          data: {
            FirebaseConstants.amount: amount.toString(),
            FirebaseConstants.status: status,
          },
        );
      },
    );
  }

  @override
  void searchDepositRequests(String query) {
    if (query.isNotEmpty) {
      final filteredTransactions = depositRequests.where((transaction) {
        return transaction.id.toString().contains(query);
      }).toList();
      emit(DepositsLoaded(filteredTransactions));
    } else {
      emit(DepositsLoaded(depositRequests));
    }
  }

  @override
  void filterByStatus(String status) {
    selectedStatus = status;

    if (status == 'all') {
      emit(DepositsLoaded(depositRequests));
    } else {
      final filtered = depositRequests
          .where((transaction) =>
      transaction.status.name.toLowerCase() == status.toLowerCase())
          .toList();
      emit(DepositsLoaded(filtered));
    }
  }
}
