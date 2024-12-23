import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  void startLoading() {
    emit(DashboardLoading());
  }

  void emitSuccess(String message) {
    emit(DashboardSuccess(message));
  }

  void emitFailure(String message) {
    emit(DashboardFailure(message));
  }

  void updateFromDate(String? date) {
    emit(state.copyWith(fromDate: date));
  }

  void updateToDate(String? date) {
    emit(state.copyWith(toDate: date));
  }
}
