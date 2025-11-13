import 'package:alfa_dashboard/core/error/failures.dart';
import 'package:alfa_dashboard/features/requests/top_up/data/data_sources/topup_remote_data_source.dart';
import 'package:alfa_dashboard/features/requests/top_up/data/models/topup_model.dart';
import 'package:alfa_dashboard/features/requests/top_up/domain/repository/topup_repository.dart';
import 'package:dartz/dartz.dart';

class TopUpRepositoryImpl implements TopUpRepository {
  final TopUpRemoteDataSource remoteDataSource;

  TopUpRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, TopUpModel>> createTopUp(TopUpModel topup) async {
    return await remoteDataSource.createTopUp(topup);
  }

  @override
  Future<Either<Failure, TopUpModel>> updateTopUpStatus(
      String topUpId, String status) async {
    return await remoteDataSource.updateTopUpStatus(topUpId, status);
  }

  @override
  Stream<List<TopUpModel>> getUserTopUps() {
    return remoteDataSource.getTopUps();
  }
}
