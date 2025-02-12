import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/paymentdetails/paymentdetails_model.dart';
import '../../../data/services/http_services.dart';
import 'payment_details_state.dart';

class PaymentDetailsCubit extends Cubit<PaymentDetailsState> {
  PaymentDetailsCubit(String projectId) : super(PaymentDetailsInitial()){
    getPaymentDetails(projectId);
  }

   Future<void> getPaymentDetails(String projectId) async {
    emit(PaymentDetailsLoading());
    try {
      GetPaymentDetails response = await HttpServices.getPaymentDetails(projectId);

      if (response.status == true) {
        emit(PaymentDetailsSuccess(response));
      } else {
        emit(PaymentDetailsFailure('Failed to fetch data}')); 
      }
    } catch (e) {
      emit(PaymentDetailsFailure('Failed to fetch data: ${e.toString()}'));
    }
  } 
}
