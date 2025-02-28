import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/dashboard/dashboard_model.dart';
import '../../../data/services/http_services.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(String fDate, String tDate) : super(DashboardInitial()) {
    getDashboard(fDate, tDate);
  }

  Future<void> getDashboard(String fDate, String tDate) async {
    emit(DashboardLoading());
    try {
      DashboardModel response = await HttpServices.dashboard(fDate, tDate);
      if (response.status == true) {
        emit(DashboardSuccess(response));
      }
    } catch (e) {
      emit(DashboardFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
