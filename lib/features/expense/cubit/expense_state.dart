import '../../../data/models/expenselist/expenselist_model.dart';

class ExpenseState {
  final DateTime? fromDate;
  final DateTime? toDate;

  ExpenseState({this.fromDate, this.toDate});

  ExpenseState copyWith({String? fromDate, String? toDate}) {
    return ExpenseState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class ExpenseInitial extends ExpenseState {
  
}

class ExpenseLoading extends ExpenseState {}

class ExpenseSuccess extends ExpenseState {
 GetExpenseList response;
 
  ExpenseSuccess(this.response);
}

class ExpenseFailure extends ExpenseState {
  final String message;
  ExpenseFailure(this.message);
}
