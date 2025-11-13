import 'dart:async';
import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/notifications/data/models/notification_model.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/send_notification_usecase.dart';
import 'package:alfa_dashboard/features/notifications/presentation/services/send_notification_services.dart';
import 'package:alfa_dashboard/features/requests/withdraw_requests/domain/usecases/fetch_withdraws_stream_usecase.dart';
import 'package:alfa_dashboard/features/requests/withdraw_requests/domain/usecases/update_withdraws_status_usecase.dart';
import 'package:alfa_dashboard/features/requests/withdraw_requests/presentation/manager/withdraw_manager.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_status.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_type.dart';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:alfa_dashboard/features/user/domain/entities/user_status.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_cubit.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
part 'withdraws_state.dart';

class WithdrawsCubit extends Cubit<WithdrawsState> implements WithdrawManager {

  final FetchWithdrawsStreamUseCase _withdrawsStreamUseCase;
  final UpdateWithdrawsStatusUseCase _updateWithdrawsUseCase;
  final SendNotificationUseCase _sendNotificationUseCase;
  final UserCubit _userCubit;

  WithdrawsCubit(
      this._withdrawsStreamUseCase,
      this._updateWithdrawsUseCase,
      this._userCubit,
      this._sendNotificationUseCase,
      ) : super(WithdrawsInitial()){
    fetchWithdrawsStream();}

  StreamSubscription? _withdrawStreamSubscription;
  String selectedStatus = 'all';

  @override
  Future<void> close() {
    _withdrawStreamSubscription?.cancel();
    return super.close();
  }

  @override
  Future<void> fetchWithdrawsStream() async {
    emit(WithdrawsLoading());
    _withdrawStreamSubscription?.cancel();
    _withdrawStreamSubscription = _withdrawsStreamUseCase().listen(
          (either) {
        either.fold(
              (failure) => emit(WithdrawsError(failure.message)),
              (result) {
            withdrawRequestsList = result;
            emit(WithdrawsLoaded(withdrawRequests));
            if (kDebugMode) {
              print("withdrawRequests data.................... ${withdrawRequests.length}");
            }
          },
        );
      },
    );
  }

  @override
  Future<void> changeWithdrawStatus(
      TransactionModel transaction,
      String newStatus, {
        String? adminNote,
        required String userId,
        required String userToken,
        required Function(String) onError,
      }) async {
    try {
      emit(WithdrawsUpdating());

      if (newStatus == TransactionStatus.completed.name) {
        final user = usersList.firstWhere((u) => u.uid == userId,
          orElse: () => UserModel(
            uid: '',
            balance: 0,
            email: '',
            displayName: '',
            emailVerified: false,
            phoneNumber: '',
            status: UserStatus.active,
            fcmToken: '',
          ),
        );
        final userBalance = user.balance;

        if (userBalance <= 100) {
          onError(AppStrings.userBalanceError);
          emit(WithdrawsLoaded(withdrawRequests));
          return;
        }
      }
      final updated = transaction.copyWith(
        status: TransactionStatusExt.fromString(newStatus),
        adminNote: adminNote ?? transaction.adminNote,
        updatedAt: DateTime.now(),
      );

      final result = await _updateWithdrawsUseCase.call(updated);

      result.fold(
            (failure) {
          emit(WithdrawsError(failure.message));
          onError(failure.message);
        },
            (_) async {
          if (newStatus == TransactionStatus.completed.name) {
            await _userCubit.updateUserBalance(-transaction.amount, userId);
          }

          await sendStatusUpdateNotification(
            userId: userId,
            userToken: userToken,
            status: newStatus,
            amount: transaction.amount,
            userName: transaction.userName,
            note: adminNote ?? transaction.adminNote,
          );

          await fetchWithdrawsStream();
          emit(WithdrawsLoaded(withdrawRequests));
        },
      );
    } catch (e) {
      const errorMsg = AppStrings.updateStatusError;
      emit(WithdrawsError(errorMsg));
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

    final title = AppStrings.updateWithdrawStatus;

    String body;
    if (status == TransactionStatus.completed.name) {
      body = 'تم تحويل مبلغ $amount إلى حسابك بنجاح';
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
      adminNote: note,
      name: userName,
      fcmToken: userToken,
      amount: amount,
      status: TransactionStatusExt.fromString(status),
      type: TransactionType.withdraw,
    );

    final result = await _sendNotificationUseCase.call(notification);

    result.fold(
          (error) => emit(WithdrawsError(error.message)),
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
  void searchWithdrawRequests(String query) {
    if (query.isNotEmpty) {
      final filteredTransactions = withdrawRequests.where((transaction) {
        return transaction.id.toString().contains(query);
      }).toList();
      emit(WithdrawsLoaded(filteredTransactions));
    } else {
      emit(WithdrawsLoaded(withdrawRequests));
    }
  }

  @override
  void filterByStatus(String status) {
    selectedStatus = status;

    if (status == 'all') {
      emit(WithdrawsLoaded(withdrawRequests));
    } else {
      final filtered = withdrawRequests
          .where((transaction) =>
      transaction.status.name.toLowerCase() == status.toLowerCase())
          .toList();
      emit(WithdrawsLoaded(filtered));
    }
  }
}

