import 'package:alfa_dashboard/core/di/injection_container.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_status.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_cubit.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_state.dart';
import 'package:alfa_dashboard/features/withdraw_requests/domain/usecases/fetch_all_withdraws_usecase.dart';
import 'package:alfa_dashboard/features/withdraw_requests/domain/usecases/update_withdraw_request_status_usecase.dart';
import 'package:alfa_dashboard/features/withdraw_requests/presentation/manager/withdraw_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawRequestsCubit extends Cubit<WithdrawRequestsState> {
  final FetchAllWithdrawsUseCase fetchAllWithdrawsUseCase;
  final UpdateWithdrawRequestStatusUseCase updateWithdrawRequestStatusUseCase;
  final UserCubit userCubit;

  WithdrawRequestsCubit({
    required this.fetchAllWithdrawsUseCase, required this.updateWithdrawRequestStatusUseCase, required this.userCubit,})
      : super(WithdrawRequestsInitial());

  final List<TransactionModel> transactions = [];
  String selectedStatus = 'all';


  Future<void> fetchAllWithdrawsRequest() async {
    emit(WithdrawRequestsLoading());

    final data = await fetchAllWithdrawsUseCase.call();

    data.fold(
          (ifLeft) => emit(WithdrawRequestsError(ifLeft.message)),
          (ifRight) {
        transactions.clear();
        transactions.addAll(ifRight);
        emit(WithdrawRequestsLoaded(transactions));
      },
    );
  }

  Future<void> changeWithdrawStatus(
      TransactionModel transaction,
      String newStatus, {
        String? adminNote,
        required String userId,
        required Function(String) onError,
      }) async {
    try {
      emit(WithdrawRequestsUpdating());

      final updated = transaction.copyWith(
        status: TransactionStatusExt.fromString(newStatus),
        adminNote: adminNote ?? transaction.adminNote,
      );

      final result = await updateWithdrawRequestStatusUseCase.call(updated);

      result.fold(
            (failure) {
          emit(WithdrawRequestsError(failure.message));
          onError(failure.message);
        },
            (_) async {
          if (newStatus == TransactionStatus.completed.name) {
            await userCubit.updateUserBalance(
                -transaction.amount,
                userId
            );
          }
          await fetchAllWithdrawsRequest();
          emit(WithdrawRequestsLoaded(transactions));
        },
      );
    } catch (e) {
      const errorMsg = 'حدث خطأ أثناء تحديث الحالة';
      emit(WithdrawRequestsError(errorMsg));
      onError(errorMsg);
    }
  }



  void searchWithdrawRequests(String query) {
    if (query.isNotEmpty) {
      final filteredTransactions = transactions.where((transaction) => transaction.type.name.contains(query.toLowerCase())).toList();
      emit(WithdrawRequestsLoaded(filteredTransactions));
    } else {
      emit(WithdrawRequestsLoaded(transactions));
    }
  }

  void filterByStatus(String status) {
    selectedStatus = status;

    if (status == 'all') {
      emit(WithdrawRequestsLoaded(transactions));
    } else {
      final filtered = transactions
          .where((transaction) =>
      transaction.status.name.toLowerCase() == status.toLowerCase())
          .toList();
      emit(WithdrawRequestsLoaded(filtered));
    }
  }
}
