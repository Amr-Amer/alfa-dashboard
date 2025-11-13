import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/requests/withdraw_requests/domain/repository/withdraws_repository.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:dartz/dartz.dart';

class UpdateWithdrawsStatusUseCase implements UseCases<TransactionModel, TransactionModel>{

  final WithdrawsRepository withdrawRepo;

  UpdateWithdrawsStatusUseCase(this.withdrawRepo);

  @override
  Future<Either<ErrorModel, TransactionModel>> call(TransactionModel transaction) async{
    return await withdrawRepo.updateRequestStatus(transaction);
  }
}
