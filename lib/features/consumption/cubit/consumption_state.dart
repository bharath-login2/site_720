class ConsumptionState {
  final DateTime? fromDate;
  final DateTime? toDate;

  ConsumptionState({this.fromDate, this.toDate});

  ConsumptionState copyWith({String? fromDate, String? toDate}) {
    return ConsumptionState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class ConsumptionInitial extends ConsumptionState {
  
}

class ConsumptionLoading extends ConsumptionState {}

class ConsumptionSuccess extends ConsumptionState {
  final String message;
  ConsumptionSuccess(this.message);
}

class ConsumptionFailure extends ConsumptionState {
  final String message;
  ConsumptionFailure(this.message);
}
