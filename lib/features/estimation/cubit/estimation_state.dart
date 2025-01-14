class EstimationState {
  final DateTime? fromDate;
  final DateTime? toDate;

  EstimationState({this.fromDate, this.toDate});

  EstimationState copyWith({String? fromDate, String? toDate}) {
    return EstimationState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class EstimationInitial extends EstimationState {
  
}

class EstimationLoading extends EstimationState {}

class EstimationSuccess extends EstimationState {
  final String message;
  EstimationSuccess(this.message);
}

class EstimationFailure extends EstimationState {
  final String message;
  EstimationFailure(this.message);
}
