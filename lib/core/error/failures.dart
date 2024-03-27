

// Failure class with Equatable
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();
  @override
  List<Object> get props => [];
}

// server failure class
class ServerFailure extends Failure {
  final String message;
  const ServerFailure({required this.message});
  @override
  List<Object> get props => [message];
}

// cache failure class
class CacheFailure extends Failure {
  final String message;
  const CacheFailure({required this.message});
  @override
  List<Object> get props => [message];
}