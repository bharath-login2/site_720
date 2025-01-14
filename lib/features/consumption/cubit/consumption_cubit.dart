import 'package:flutter_bloc/flutter_bloc.dart';

import 'consumption_state.dart';

class ConsumptionCubit extends Cubit<ConsumptionState> {
  ConsumptionCubit() : super(ConsumptionInitial());

  void startLoading() {
    emit(ConsumptionLoading());
  }

  void emitSuccess(String message) {
    emit(ConsumptionSuccess(message));
  }

  void emitFailure(String message) {
    emit(ConsumptionFailure(message));
  }

  void updateFromDate(String? date) {
    emit(state.copyWith(fromDate: date));
  }

  void updateToDate(String? date) {
    emit(state.copyWith(toDate: date));
  }
}
