import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/transaction/domain/repository/transaction_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteTransactionUseCase implements UseCases<Unit, String> {
  final TransactionRepository repo;

  DeleteTransactionUseCase(this.repo);

  @override
  Future<Either<ErrorModel, Unit>> call(String transactionId) async {
    return await repo.deleteTransaction(transactionId);
  }
}