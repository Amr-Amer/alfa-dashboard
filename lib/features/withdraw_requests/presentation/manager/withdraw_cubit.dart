import 'dart:async';
import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/core/services/notifications/notification_service.dart';
import 'package:alfa_dashboard/features/notifications/data/models/notification_model.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/send_notification_usecase.dart';
import 'package:alfa_dashboard/features/notifications/presentation/services/send_notification_services.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_status.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_type.dart';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:alfa_dashboard/features/user/domain/entities/user_status.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_cubit.dart';
import 'package:alfa_dashboard/features/withdraw_requests/domain/usecases/fetch_all_withdraws_usecase.dart';
import 'package:alfa_dashboard/features/withdraw_requests/domain/usecases/get_eithdraw_requests_stream_usecase.dart';
import 'package:alfa_dashboard/features/withdraw_requests/domain/usecases/update_withdraw_request_status_usecase.dart';
import 'package:alfa_dashboard/features/withdraw_requests/presentation/manager/withdraw_state.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawRequestsCubit extends Cubit<WithdrawRequestsState> {
  final FetchAllWithdrawsUseCase fetchAllWithdrawsUseCase;
  final UpdateWithdrawRequestStatusUseCase updateWithdrawRequestStatusUseCase;
  final UserCubit userCubit;
  final SendNotificationUseCase sendNotificationUseCase;
  final NotificationService notificationService;
  final GetWithdrawRequestsStreamUseCase getWithdrawRequestsStreamUseCase;

  WithdrawRequestsCubit({
    required this.fetchAllWithdrawsUseCase,
    required this.updateWithdrawRequestStatusUseCase,
    required this.userCubit,
    required this.notificationService,
    required this.sendNotificationUseCase,
    required this.getWithdrawRequestsStreamUseCase,
  }) : super(WithdrawRequestsInitial()) {
    setupWithdrawRequestsStream();
    userCubit.fetchUserData();
  }

  String selectedStatus = 'all';

  StreamSubscription? _withdrawStreamSubscription;

  Future<void> setupWithdrawRequestsStream() async {
    emit(WithdrawRequestsLoading());
    _withdrawStreamSubscription?.cancel();
    _withdrawStreamSubscription = getWithdrawRequestsStreamUseCase().listen(
          (either) {
        either.fold(
              (failure) => emit(WithdrawRequestsError(failure.message)),
              (result) {
            withdrawRequestsList = result;
            emit(WithdrawRequestsLoaded(withdrawRequests));
            if (kDebugMode) {
              print("withdrawRequests data.................... ${withdrawRequests.length}");
            }
          },
        );
      },
    );
  }

  @override
  Future<void> close() {
    _withdrawStreamSubscription?.cancel();
    return super.close();
  }


  Future<void> changeWithdrawStatus(
      TransactionModel transaction,
      String newStatus, {
        String? adminNote,
        required String userId,
        required String userToken,
        required Function(String) onError,
      }) async {
    try {
      emit(WithdrawRequestsUpdating());

      if (newStatus == TransactionStatus.completed.name) {

        final user = usersList.firstWhere(
              (u) => u.uid == userId,
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

        if (kDebugMode) {
          print("userBalance: $userBalance");
        }

        if (userBalance <= 100) {
          onError(AppStrings.userBalanceError);
          emit(WithdrawRequestsLoaded(withdrawRequests));
          return;
        }
      }


      final updated = transaction.copyWith(
        status: TransactionStatusExt.fromString(newStatus),
        adminNote: adminNote ?? transaction.adminNote,
        updatedAt: DateTime.now(),
      );

      final result = await updateWithdrawRequestStatusUseCase.call(updated);

      result.fold(
            (failure) {
          emit(WithdrawRequestsError(failure.message));
          onError(failure.message);
        },
            (_) async {
          if (newStatus == TransactionStatus.completed.name) {
            await userCubit.updateUserBalance(-transaction.amount, userId);
          }

          await _sendStatusUpdateNotification(
            userId: userId,
            userToken: userToken,
            status: newStatus,
            amount: transaction.amount,
            userName: transaction.userName,
            note: adminNote ?? transaction.adminNote,
          );

          await setupWithdrawRequestsStream();
          emit(WithdrawRequestsLoaded(withdrawRequests));
        },
      );
    } catch (e) {
      const errorMsg = AppStrings.updateStatusError;
      emit(WithdrawRequestsError(errorMsg));
      onError(errorMsg);
    }
  }


  Future<void> _sendStatusUpdateNotification({
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
      data: {
        FirebaseConstants.amount: amount.toString(),
        FirebaseConstants.status: status,
        FirebaseConstants.type: TransactionType.withdraw.name,
      },
    );

    final result = await sendNotificationUseCase.call(notification);

    result.fold(
          (error) => emit(WithdrawRequestsError(error.message)),
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

  void searchWithdrawRequests(String query) {
    if (query.isNotEmpty) {
      final filteredTransactions = withdrawRequests.where((transaction) {
        return transaction.id.toString().contains(query);
      }).toList();
      emit(WithdrawRequestsLoaded(filteredTransactions));
    } else {
      emit(WithdrawRequestsLoaded(withdrawRequests));
    }
  }

  void filterByStatus(String status) {
    selectedStatus = status;

    if (status == 'all') {
      emit(WithdrawRequestsLoaded(withdrawRequests));
    } else {
      final filtered = withdrawRequests
          .where((transaction) =>
      transaction.status.name.toLowerCase() == status.toLowerCase())
          .toList();
      emit(WithdrawRequestsLoaded(filtered));
    }
  }
}
