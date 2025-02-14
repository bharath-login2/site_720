import '../../../data/models/paymentdetails/paymentdetails_model.dart';

class PaymentDetailsState {
  final DateTime? fromDate;
  final DateTime? toDate;

  PaymentDetailsState({this.fromDate, this.toDate});

  get response => null;

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
 @override
  GetPaymentDetails response;
  PaymentDetailsSuccess(this.response);
}

class PaymentDetailsFailure extends PaymentDetailsState {
  final String message;
  PaymentDetailsFailure(this.message);
}
