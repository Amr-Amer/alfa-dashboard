import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/domain/repository/deposits_repository.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:dartz/dartz.dart';

class UpdateDepositsStatusUseCase implements UseCases<TransactionModel, TransactionModel>{

  final DepositsRepository _depositsRepo;

  UpdateDepositsStatusUseCase(this._depositsRepo);

  @override
  Future<Either<ErrorModel, TransactionModel>> call(TransactionModel transaction) async{
    return await _depositsRepo.updateRequestStatus(transaction);
  }
}
