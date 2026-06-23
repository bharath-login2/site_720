import '../../../data/models/dashboard/dashboard_model.dart';

class DashboardState {
  final DateTime? fromDate;
  final DateTime? toDate;

  DashboardState({this.fromDate, this.toDate});

  DashboardState copyWith({
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return DashboardState(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final DashboardModel response;
  DashboardSuccess(this.response);
}

class DashboardFailure extends DashboardState {
  final String message;
  DashboardFailure(this.message);
}

class GetExpenseLoading extends DashboardState {}

class GetExpenseSuccess extends DashboardState {
  final dynamic response;

  GetExpenseSuccess(this.response);
}

class GetExpenseFailure extends DashboardState {
  final String error;

  GetExpenseFailure(this.error);
}
