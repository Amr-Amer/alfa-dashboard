import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/withdraw_requests/domain/repository/withdraw_repository.dart';
import 'package:dartz/dartz.dart';

class FetchAllWithdrawsUseCase implements UseCasesNoParams<List<TransactionModel >> {
  final WithdrawRepository repo;

  FetchAllWithdrawsUseCase(this.repo);

  @override
  Future<Either<ErrorModel, List<TransactionModel>>> call() {
    return repo.fetchAllWithdraws();
  }
}
