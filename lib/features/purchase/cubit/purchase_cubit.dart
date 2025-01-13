import 'package:flutter_bloc/flutter_bloc.dart';

import 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  PurchaseCubit() : super(PurchaseInitial());

  void startLoading() {
    emit(PurchaseLoading());
  }

  void emitSuccess(String message) {
    emit(PurchaseSuccess(message));
  }

  void emitFailure(String message) {
    emit(PurchaseFailure(message));
  }

  void updateFromDate(String? date) {
    emit(state.copyWith(fromDate: date));
  }

  void updateToDate(String? date) {
    emit(state.copyWith(toDate: date));
  }
}
