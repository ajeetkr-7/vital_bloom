import 'package:equatable/equatable.dart';
import '../../../models/user.dart';


abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object?> get props => [];
}

class UserLoading extends UserState {}

class UserUninitialized extends UserState {}

class UserUnauthenticated extends UserState {}

class UserAuthenticated extends UserState {
  final User user;

  const UserAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}
