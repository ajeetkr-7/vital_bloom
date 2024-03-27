import 'package:dartz/dartz.dart';
import '../error/failures.dart';
import 'params.dart';

abstract class UseCase<Type, Params extends Param> {
  Future<Either<Failure, Type>> call(Params params);
}