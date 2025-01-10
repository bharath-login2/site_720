import 'package:flutter_bloc/flutter_bloc.dart';

import 'extra_work_state.dart';

class ExtraWorkCubit extends Cubit<ExtraWorkState> {
  ExtraWorkCubit() : super(ExtraWorkInitial());

  void startLoading() {
    emit(ExtraWorkLoading());
  }

  void emitSuccess(String message) {
    emit(ExtraWorkSuccess(message));
  }

  void emitFailure(String message) {
    emit(ExtraWorkFailure(message));
  }

  void updateFromDate(String? date) {
    emit(state.copyWith(fromDate: date));
  }

  void updateToDate(String? date) {
    emit(state.copyWith(toDate: date));
  }
}
