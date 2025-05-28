import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/expenselist/expenselist_model.dart';
import '../../../data/services/http_services.dart';
import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit(String projectId,String expenseId,String type) : super(ExpenseInitial()){
    getExpenseList(projectId,expenseId, type);
  }
   Future<void> getExpenseList(String projectId,String expenseId,String type) async {
    emit(ExpenseLoading());
    try {
      GetExpenseList response = await HttpServices.getExpenseList(projectId,expenseId,type);

      if (response.status == true) {
        emit(ExpenseSuccess(response));
      } else {
        emit(ExpenseFailure('Failed to fetch data}')); 
      }
    } catch (e) {
      emit(ExpenseFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
