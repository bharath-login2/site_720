class ExtraWorkState {
  final DateTime? fromDate;
  final DateTime? toDate;

  ExtraWorkState({this.fromDate, this.toDate});

  ExtraWorkState copyWith({String? fromDate, String? toDate}) {
    return ExtraWorkState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class ExtraWorkInitial extends ExtraWorkState {
  
}

class ExtraWorkLoading extends ExtraWorkState {}

class ExtraWorkSuccess extends ExtraWorkState {
  final String message;
  ExtraWorkSuccess(this.message);
}

class ExtraWorkFailure extends ExtraWorkState {
  final String message;
  ExtraWorkFailure(this.message);
}
