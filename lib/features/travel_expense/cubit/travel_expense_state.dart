import '../../../data/models/travel_expense/travel_expense_model.dart';

abstract class TravelExpenseState {}

class TravelExpenseInitial extends TravelExpenseState {}

/// LIST LOADING
class TravelExpenseLoading extends TravelExpenseState {}

/// LIST SUCCESS
class TravelExpenseSuccess extends TravelExpenseState {
  final TravelExpenseModel response;

  TravelExpenseSuccess(this.response);
}

/// POST LOADING
class TravelExpensePostLoading extends TravelExpenseState {}

/// POST SUCCESS
class TravelExpensePostSuccess extends TravelExpenseState {
  final String message;

  TravelExpensePostSuccess(this.message);
}

/// FAILURE
class TravelExpenseFailure extends TravelExpenseState {
  final String error;

  TravelExpenseFailure(this.error);
}
