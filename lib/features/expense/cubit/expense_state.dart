import '../../../data/models/expenselist/expenselist_model.dart';

class ExpenseState {
  final DateTime? fromDate;
  final DateTime? toDate;

  const ExpenseState({
    this.fromDate,
    this.toDate,
  });

  ExpenseState copyWith({
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return ExpenseState(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }
}

class ExpenseInitial extends ExpenseState {
  const ExpenseInitial();
}

class ExpenseLoading extends ExpenseState {
  const ExpenseLoading();
}

class ExpenseSuccess extends ExpenseState {
  final GetExpenseList response;

  const ExpenseSuccess(
    this.response,
  );
}

class ExpenseFailure extends ExpenseState {
  final String message;

  const ExpenseFailure(
    this.message,
  );
}
