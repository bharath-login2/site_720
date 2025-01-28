import 'package:flutter_bloc/flutter_bloc.dart';

import 'complaint_state.dart';

class ComplaintCubit extends Cubit<ComplaintState> {
  ComplaintCubit() : super(ComplaintInitial());

  void startLoading() {
    emit(ComplaintLoading());
  }

  void emitSuccess(String message) {
    emit(ComplaintSuccess(message));
  }

  void emitFailure(String message) {
    emit(ComplaintFailure(message));
  }

  void updateFromDate(String? date) {
    emit(state.copyWith(fromDate: date));
  }

  void updateToDate(String? date) {
    emit(state.copyWith(toDate: date));
  }
}
