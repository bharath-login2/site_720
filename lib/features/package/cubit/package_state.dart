import '../../../data/models/package/package_model.dart';

class PackageState {
  final DateTime? fromDate;
  final DateTime? toDate;

  PackageState({this.fromDate, this.toDate});

  PackageState copyWith({String? fromDate, String? toDate}) {
    return PackageState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class PackageInitial extends PackageState {}

class PackageLoading extends PackageState {}

class PackageSuccess extends PackageState {
  PackageModel response;
  PackageSuccess(this.response);
}

class PackageFailure extends PackageState {
  final String message;
  PackageFailure(this.message);
}
