class PackageDetailedState {
  final DateTime? fromDate;
  final DateTime? toDate;

  PackageDetailedState({this.fromDate, this.toDate});

  PackageDetailedState copyWith({String? fromDate, String? toDate}) {
    return PackageDetailedState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class PackageDetailedInitial extends PackageDetailedState {
  
}

class PackageDetailedLoading extends PackageDetailedState {}

class PackageDetailedSuccess extends PackageDetailedState {
  final String message;
  PackageDetailedSuccess(this.message);
}

class PackageDetailedFailure extends PackageDetailedState {
  final String message;
  PackageDetailedFailure(this.message);
}
