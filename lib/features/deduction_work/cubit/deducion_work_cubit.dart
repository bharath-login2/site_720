import 'package:flutter_bloc/flutter_bloc.dart';

import 'deduction_work_state.dart';

class DeductionWorkCubit extends Cubit<DeductionWorkState> {
  DeductionWorkCubit() : super(DeductionWorkInitial());

  void startLoading() {
    emit(DeductionWorkLoading());
  }

  void emitSuccess(String message) {
    emit(DeductionWorkSuccess(message));
  }

  void emitFailure(String message) {
    emit(DeductionWorkFailure(message));
  }

  void updateFromDate(String? date) {
    emit(state.copyWith(fromDate: date));
  }

  void updateToDate(String? date) {
    emit(state.copyWith(toDate: date));
  }
}
