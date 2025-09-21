import 'package:alfa_dashboard/core/networking/firebase_error_handler.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/transaction/domain/repository/transaction_repository.dart';
import 'package:dartz/dartz.dart';

class FetchAllTransactionsStreamUseCase
    implements StreamUseCaseNoParamWithFirebase<List<TransactionModel>> {
  final TransactionRepository repository;

  FetchAllTransactionsStreamUseCase(this.repository);

  @override
  Stream<Either<FirebaseFailure, List<TransactionModel>>> call() {
    return repository.fetchAllTransactionsStream().map(
          (transactions) => Right<FirebaseFailure, List<TransactionModel>>(transactions),
    );
  }
}