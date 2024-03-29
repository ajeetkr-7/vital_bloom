import 'package:bloc/bloc.dart';
import 'package:vital_bloom/services/auth_service.dart';
import 'uesr_state.dart';

class DashboardBloc extends Cubit<DashboardState> {
  final AuthService authService;
  DashboardBloc({required this.authService}) : super(DashboardUninitialized());

  loadDashboard(userId) async {
    try {
      emit(DashboardLoading());
      final data = await authService.getDashboardData(userId: userId);
      emit(DashboardLoaded(data));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
