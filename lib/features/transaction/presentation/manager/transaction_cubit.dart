import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/transaction/domain/usecases/delete_transaction_usecase.dart';
import 'package:alfa_dashboard/features/transaction/domain/usecases/fetch_all_transaction_usecase.dart';
import 'package:alfa_dashboard/features/transaction/domain/usecases/fetch_user_transaction_usecase.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final FetchUserTransactionUseCase fetchUserTransactionUseCase;
  final FetchAllTransactionUseCase fetchAllTransactionsUseCase;
  final DeleteTransactionUseCase deleteTransactionUseCase;

  TransactionCubit({required this.fetchUserTransactionUseCase, required this.fetchAllTransactionsUseCase, required this.deleteTransactionUseCase})
      : super(TransactionInitial());

  final List<TransactionModel> transactions = [];
  String selectedStatus = 'all';
  String selectedType = 'all';
  String selectedMethod = 'all';

  Future<void> fetchTransactions() async {
    emit(TransactionLoading());
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      emit(TransactionError(AppStrings.userNotAuthenticated));
      return;
    }

    final data = await fetchUserTransactionUseCase.call(uid);

    data.fold(
          (ifLeft) => emit(TransactionError(ifLeft.message)),
          (ifRight) {
        transactions.clear();
        transactions.addAll(ifRight);
        emit(TransactionsLoaded(transactions));
      },
    );
  }


  Future<void> fetchAllTransactions() async {
    emit(TransactionLoading());

    final data = await fetchAllTransactionsUseCase.call();

    data.fold(
          (ifLeft) => emit(TransactionError(ifLeft.message)),
          (ifRight) {
        transactions.clear();
        transactions.addAll(ifRight);
        emit(TransactionsLoaded(transactions));
      },
    );
  }

  Future<bool> deleteTransaction(String id) async {
    emit(TransactionDeleting(id));
    try {
      await deleteTransactionUseCase.call(id);
      emit(TransactionDeleted(message: "تم الحذف بنجاح"));
      return true;
    } catch (e) {
      emit(TransactionDeleteError("فشل في الحذف"));
      return false;
    }
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


}
