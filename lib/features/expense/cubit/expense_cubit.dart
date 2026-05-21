import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/expenselist/expenselist_model.dart';
import '../../../data/services/http_services.dart';
import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit(String projectId)
      : super(
          const ExpenseInitial(),
        ) {
    getExpenseList(projectId);
  }

  Future<void> getExpenseList(
    String projectId,
  ) async {
    emit(
      const ExpenseLoading(),
    );

    try {
      GetExpenseList response = await HttpServices.getExpenseList(
        projectId,
      );

      if (response.status == true) {
        emit(
          ExpenseSuccess(response),
        );
      } else {
        emit(
          const ExpenseFailure(
            'Failed to fetch data',
          ),
        );
      }
    } catch (e) {
      emit(
        ExpenseFailure(
          'Failed to fetch data: ${e.toString()}',
        ),
      );
    }
  }
}
