import 'package:alfa_dashboard/core/error/failures.dart';
import 'package:alfa_dashboard/features/requests/top_up/data/models/topup_model.dart';
import 'package:dartz/dartz.dart';

abstract class TopUpRepository {
  Future<Either<Failure, TopUpModel>> createTopUp(TopUpModel topUp);
  Future<Either<Failure, TopUpModel>> updateTopUpStatus(
      String topUpId, String status);
  Stream<List<TopUpModel>> getUserTopUps();
}
