class StagesState {
  final DateTime? fromDate;
  final DateTime? toDate;

  StagesState({this.fromDate, this.toDate});

  StagesState copyWith({String? fromDate, String? toDate}) {
    return StagesState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class StagesInitial extends StagesState {
  
}

class StagesLoading extends StagesState {}

class StagesSuccess extends StagesState {
  final String message;
  StagesSuccess(this.message);
}

class StagesFailure extends StagesState {
  final String message;
  StagesFailure(this.message);
}
