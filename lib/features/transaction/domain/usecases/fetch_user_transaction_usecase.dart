import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/transaction/domain/repository/transaction_repository.dart';
import 'package:dartz/dartz.dart';

class FetchUserTransactionUseCase implements UseCases<List<TransactionModel>, String> {
  final TransactionRepository repo;

  FetchUserTransactionUseCase(this.repo);

  @override
  Future<Either<ErrorModel, List<TransactionModel>>> call(String uId){
    return repo.fetchUserTransactions(uId);
  }
}
