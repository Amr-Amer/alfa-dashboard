import 'dart:async';
import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/transaction/domain/usecases/delete_transaction_usecase.dart';
import 'package:alfa_dashboard/features/transaction/domain/usecases/fetch_all_transaction_usecase.dart';
import 'package:alfa_dashboard/features/transaction/domain/usecases/fetch_all_transactions_stream_usecase.dart';
import 'package:alfa_dashboard/features/transaction/domain/usecases/fetch_user_transaction_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final FetchUserTransactionUseCase fetchUserTransactionUseCase;
  final FetchAllTransactionUseCase fetchAllTransactionsUseCase;
  final DeleteTransactionUseCase deleteTransactionUseCase;
  final FetchAllTransactionsStreamUseCase fetchAllTransactionsStreamUseCase;

  TransactionCubit({
    required this.fetchUserTransactionUseCase,
    required this.fetchAllTransactionsUseCase,
    required this.deleteTransactionUseCase,
    required this.fetchAllTransactionsStreamUseCase})
      : super(TransactionInitial()) ;

  String selectedStatus = 'all';
  String selectedType = 'all';
  String selectedMethod = 'all';

  StreamSubscription? _usersSubscription;

  Future<void> fetchAllTransactionsStream()  async {
    emit(TransactionLoading());
    _usersSubscription?.cancel();
    _usersSubscription = fetchAllTransactionsStreamUseCase().listen(
          (either) {
        either.fold(
              (failure) => emit(TransactionError(failure.message)),
              (result) {
                transactionsList = result;
            emit(TransactionsLoaded(transactions));
                if (kDebugMode) {
                  print("transaction data.................... ${transactions.length}");
                }
          },
        );
      },
    );
  }


  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    return super.close();
  }


  // Future<void> deleteTransaction(String id) async {
  //   final result = await deleteTransactionUseCase.call(id);
  //
  //   result.fold(
  //         (error) => emit(TransactionError(error.message)),
  //         (_) {
  //       emit(TransactionDeleted(message: 'تم حذف المعاملة بنجاح'));
  //     },
  //   );
  // }

  Future<void> deleteTransaction(String uid) async {

    final result = await deleteTransactionUseCase.call(uid);

    result.fold(
          (error) => emit(TransactionError(error.message)),
          (_)async {
        await fetchAllTransactionsStream();
        emit(TransactionsLoaded(transactions));
        emit(TransactionDeleted(message: 'تم حذف المعاملة بنجاح'));
      },
    );
  }


  void searchTransactions(String query) {
    if (query.isNotEmpty) {
      final filteredTransactions = transactions.where((transaction) => transaction.id.contains(query.toLowerCase())).toList();
      emit(TransactionsLoaded(filteredTransactions));
    } else {
      emit(TransactionsLoaded(transactions));
    }
  }


  void filterByStatus(String status) {
    selectedStatus = status;

    if (status == 'all') {
      emit(TransactionsLoaded(transactions));
    } else {
      final filtered = transactions
          .where((transaction) =>
      transaction.status.name.toLowerCase() == status.toLowerCase())
          .toList();
      emit(TransactionsLoaded(filtered));
    }
  }

  void filterByType(String type) {
    selectedType = type;

    if (type == 'all') {
      emit(TransactionsLoaded(transactions));
    } else {
      final filtered = transactions
          .where((transaction) =>
      transaction.type.name.toLowerCase() == type.toLowerCase())
          .toList();
      emit(TransactionsLoaded(filtered));
    }
  }

  void filterByMethod(String method) {
    selectedMethod = method;

    if (method == 'all') {
      emit(TransactionsLoaded(transactions));
    } else {
      final filtered = transactions
          .where((transaction) =>
      transaction.method.name.toLowerCase() == method.toLowerCase())
          .toList();
      emit(TransactionsLoaded(filtered));
    }
  }

  void filterByDateRange(DateTime from, DateTime to) {
    final filtered = transactions.where((transaction) {
      final created = transaction.createdAt;
      return created.isAfter(from.subtract(const Duration(seconds: 1))) &&
          created.isBefore(to.add(const Duration(days: 1)));
    }).toList();

    emit(TransactionsLoaded(filtered));
  }


}
