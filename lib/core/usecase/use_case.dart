import 'package:alfa_dashboard/core/networking/firebase_error_handler.dart';
import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:dartz/dartz.dart';

abstract class UseCases<ReturnType , Param>{
  Future<Either<ErrorModel , ReturnType>> call(Param param);
}
abstract class UseCasesNoParams<Type> {
  Future<Either<ErrorModel, Type>> call();
}

abstract class UseCasesWithFireBase<ReturnType , Param>{
  Future<Either<FirebaseFailure , ReturnType>> call(Param param);
}
abstract class UseCasesNoParamsWithFireBase<Type> {
  Future<Either<FirebaseFailure, Type>> call();
}

abstract class StreamUseCase<ReturnType, Param> {
  Stream<Either<ErrorModel, ReturnType>> call(Param param);
}

abstract class StreamUseCaseNoParam<ReturnType> {
  Stream<Either<ErrorModel, ReturnType>> call();
}

abstract class StreamUseCaseWithFirebase<ReturnType, Param> {
  Stream<Either<FirebaseFailure, ReturnType>> call(Param param);
}

abstract class StreamUseCaseNoParamWithFirebase<ReturnType> {
  Stream<Either<FirebaseFailure, ReturnType>> call();
}


class NoParams {}