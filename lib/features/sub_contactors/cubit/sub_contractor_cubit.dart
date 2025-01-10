import 'package:flutter_bloc/flutter_bloc.dart';

import 'sub_contractor_state.dart';

class StagesCubit extends Cubit<StagesState> {
  StagesCubit() : super(StagesInitial());

  void startLoading() {
    emit(StagesLoading());
  }

  void emitSuccess(String message) {
    emit(StagesSuccess(message));
  }

  void emitFailure(String message) {
    emit(StagesFailure(message));
  }

  void updateFromDate(String? date) {
    emit(state.copyWith(fromDate: date));
  }

  void updateToDate(String? date) {
    emit(state.copyWith(toDate: date));
  }
}
