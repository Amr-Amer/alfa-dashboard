import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/withdraw_requests/domain/repository/withdraw_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateWithdrawRequestStatusUseCase implements UseCases<TransactionModel, TransactionModel>{

  final WithdrawRepository withdrawRepo;

  UpdateWithdrawRequestStatusUseCase(this.withdrawRepo);

  @override
  Future<Either<ErrorModel, TransactionModel>> call(TransactionModel transaction) async{
    return await withdrawRepo.updateWithdrawRequestStatus(transaction);
  }
}
