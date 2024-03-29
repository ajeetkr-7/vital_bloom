import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardLoading extends DashboardState {}

class DashboardUninitialized extends DashboardState {}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class DashboardLoaded extends DashboardState {
  final Map<String, dynamic> data;

  const DashboardLoaded(this.data);

  @override
  List<Object?> get props => [data];
}
