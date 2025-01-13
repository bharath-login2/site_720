import 'package:flutter_bloc/flutter_bloc.dart';

import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(ExpenseInitial());

  void startLoading() {
    emit(ExpenseLoading());
  }

  void emitSuccess(String message) {
    emit(ExpenseSuccess(message));
  }

  void emitFailure(String message) {
    emit(ExpenseFailure(message));
  }

  void updateFromDate(String? date) {
    emit(state.copyWith(fromDate: date));
  }

  void updateToDate(String? date) {
    emit(state.copyWith(toDate: date));
  }
}
