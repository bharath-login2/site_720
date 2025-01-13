import 'package:flutter_bloc/flutter_bloc.dart';

import 'payment_details_state.dart';

class PaymentDetailsCubit extends Cubit<PaymentDetailsState> {
  PaymentDetailsCubit() : super(PaymentDetailsInitial());

  void startLoading() {
    emit(PaymentDetailsLoading());
  }

  void emitSuccess(String message) {
    emit(PaymentDetailsSuccess(message));
  }

  void emitFailure(String message) {
    emit(PaymentDetailsFailure(message));
  }

  void updateFromDate(String? date) {
    emit(state.copyWith(fromDate: date));
  }

  void updateToDate(String? date) {
    emit(state.copyWith(toDate: date));
  }
}
