import 'package:flutter_bloc/flutter_bloc.dart';

import 'estimation_state.dart';

class EstimationCubit extends Cubit<EstimationState> {
  EstimationCubit() : super(EstimationInitial());

  void startLoading() {
    emit(EstimationLoading());
  }

  void emitSuccess(String message) {
    emit(EstimationSuccess(message));
  }

  void emitFailure(String message) {
    emit(EstimationFailure(message));
  }

  void updateFromDate(String? date) {
    emit(state.copyWith(fromDate: date));
  }

  void updateToDate(String? date) {
    emit(state.copyWith(toDate: date));
  }
}
