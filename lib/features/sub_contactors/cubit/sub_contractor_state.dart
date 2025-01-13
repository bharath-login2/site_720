class SubContractorState {
  final DateTime? fromDate;
  final DateTime? toDate;

  SubContractorState({this.fromDate, this.toDate});

  SubContractorState copyWith({String? fromDate, String? toDate}) {
    return SubContractorState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class SubContractorInitial extends SubContractorState {
  
}

class SubContractorLoading extends SubContractorState {}

class SubContractorSuccess extends SubContractorState {
  final String message;
  SubContractorSuccess(this.message);
}

class SubContractorFailure extends SubContractorState {
  final String message;
  SubContractorFailure(this.message);
}
