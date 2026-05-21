part of 'add_expense_cubit.dart';

abstract class AddExpenseState {}

class AddExpenseInitial extends AddExpenseState {}

class AddExpenseLoading extends AddExpenseState {}

class AddExpenseSuccess extends AddExpenseState {
  final String message;

  AddExpenseSuccess(this.message);
}

class AddExpenseFailure extends AddExpenseState {
  final String error;

  AddExpenseFailure(this.error);
}
