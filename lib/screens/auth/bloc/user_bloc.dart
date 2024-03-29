import 'package:bloc/bloc.dart';
import 'package:vital_bloom/models/user.dart';
import 'package:vital_bloom/services/auth_service.dart';
import 'uesr_state.dart';

class UserBloc extends Cubit<UserState> {
  final AuthService authService;
  UserBloc({required this.authService}) : super(UserUninitialized());

  loadUser() {
    try {
      final user = authService.getUser();
      if (user != null)
        emit(UserAuthenticated(user));
      else
        emit(UserUnauthenticated());
    } catch (e) {
      emit(UserUnauthenticated());
    }
  }

  Future<void> setUser(User user) async {
    emit(UserAuthenticated(user));
    print("state is $state inside setUser");
  }

  Future<void> clearUser() async {
    emit(UserUnauthenticated());
  }
}
