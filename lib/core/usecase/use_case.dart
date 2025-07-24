import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:dartz/dartz.dart';

abstract class UseCases<ReturnType , Param>{
  Future<Either<ErrorModel , ReturnType>> call(Param param);
}
abstract class UseCasesNoParams<Type> {
  Future<Either<ErrorModel, Type>> call();
}

class NoParams {}