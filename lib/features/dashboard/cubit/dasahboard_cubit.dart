import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/dashboard/dashboard_model.dart';
import '../../../data/services/http_services.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(String fDate, String tDate) : super(DashboardInitial()) {
    getDashboard(fDate, tDate);
    checkTokenExpirationStatus();
  }

  Future<void> getDashboard(String fDate, String tDate) async {
    emit(DashboardLoading());

    try {
      DashboardModel response = await HttpServices.dashboard(fDate, tDate);

      if (response.status == true) {
        emit(DashboardSuccess(response));
      } else {
        emit(
          DashboardFailure(
            response.message ?? 'Failed to fetch dashboard data',
          ),
        );
      }
    } catch (e) {
      emit(
        DashboardFailure(
          'Failed to fetch data: ${e.toString()}',
        ),
      );
    }
  }

  //token check
  Future<void> checkTokenExpirationStatus() async {
    try {
      // Call your static service method
      bool? isExpired = await HttpServices.isTokenExpired();

      if (isExpired == true) {
        print("TOKEN EXPIRED / LOGGED IN ELSEWHERE - LOGGING OUT");
        emit(DashboardTokenExpired());
        return;
      }

      // If false or null (network error), do nothing and let normal data loading continue
    } catch (e) {
      print("Error checking token expiration: $e");
    }
  }

  Future<void> getExpense({
    required String fromDate,
    required String toDate,
  }) async {
    emit(GetExpenseLoading());

    try {
      final response = await HttpServices.getExpense(
        fromDate: fromDate,
        toDate: toDate,
      );

      if (response != null && response['status'] == true) {
        print('Expense Response: $response');
        emit(GetExpenseSuccess(response));
      } else {
        emit(
          GetExpenseFailure(
            response['message'] ?? "Something went wrong",
          ),
        );
      }
    } catch (e) {
      emit(GetExpenseFailure(e.toString()));
    }
  }
}
