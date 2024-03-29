import 'package:equatable/equatable.dart';

abstract class GroupState extends Equatable {
  const GroupState();
  @override
  List<Object?> get props => [];
}

class GroupLoading extends GroupState {}

class GroupUninitialized extends GroupState {}

class GroupError extends GroupState {
  final String message;

  const GroupError(this.message);

  @override
  List<Object?> get props => [message];
}

class GroupLoaded extends GroupState {
  final Map<String, dynamic> data;

  const GroupLoaded(this.data);

  @override
  List<Object?> get props => [data];
}
