class PaymentDetailsState {
  final DateTime? fromDate;
  final DateTime? toDate;

  PaymentDetailsState({this.fromDate, this.toDate});

  PaymentDetailsState copyWith({String? fromDate, String? toDate}) {
    return PaymentDetailsState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class PaymentDetailsInitial extends PaymentDetailsState {
  
}

class PaymentDetailsLoading extends PaymentDetailsState {}

class PaymentDetailsSuccess extends PaymentDetailsState {
  final String message;
  PaymentDetailsSuccess(this.message);
}

class PaymentDetailsFailure extends PaymentDetailsState {
  final String message;
  PaymentDetailsFailure(this.message);
}
