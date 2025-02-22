import '../../../data/models/paymentdetails/paymentdetails_model.dart';

class PaymentDetailsState {
  PaymentDetailsState();
}

class PaymentDetailsInitial extends PaymentDetailsState {}

class PaymentDetailsLoading extends PaymentDetailsState {}

class PaymentDetailsSuccess extends PaymentDetailsState {
  GetPaymentDetails response;
  PaymentDetailsSuccess(this.response);
}

class PaymentDetailsFailure extends PaymentDetailsState {
  final String message;
  PaymentDetailsFailure(this.message);
}
