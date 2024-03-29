import 'package:bloc/bloc.dart';
import 'package:vital_bloom/services/auth_service.dart';
import 'group_state.dart';

class GroupBloc extends Cubit<GroupState> {
  final AuthService authService;
  GroupBloc({required this.authService}) : super(GroupUninitialized());

  loadGroup(userId, groupId) async {
    try {
      emit(GroupLoading());
      final data =
          await authService.getGroupData(userId: userId, groupId: groupId);
      emit(GroupLoaded(data));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }
}
