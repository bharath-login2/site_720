class DeductionWorkState {
  final DateTime? fromDate;
  final DateTime? toDate;

  DeductionWorkState({this.fromDate, this.toDate});

  DeductionWorkState copyWith({String? fromDate, String? toDate}) {
    return DeductionWorkState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class DeductionWorkInitial extends DeductionWorkState {
  
}

class DeductionWorkLoading extends DeductionWorkState {}

class DeductionWorkSuccess extends DeductionWorkState {
  final String message;
  DeductionWorkSuccess(this.message);
}

class DeductionWorkFailure extends DeductionWorkState {
  final String message;
  DeductionWorkFailure(this.message);
}
