import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/data/models/workdetails/work_detail_model.dart';

import '../../../data/services/http_services.dart';
import 'work_details_state.dart';

class WorkDetailsCubit extends Cubit<WorkDetailsState> {
  WorkDetailsCubit(String projectId) : super(WorkDetailsInitial()){
    workDetails(projectId);
  }

  void startLoading() {
    emit(WorkDetailsLoading());
  }

  void emitSuccess(WorkDetailModel response) {
    emit(WorkDetailsSuccess(response));
  }

  void emitFailure(String message) {
    emit(WorkDetailsFailure(message));
  }

  void updateFromDate(String? date) {
    emit(state.copyWith(fromDate: date));
  }

  void updateToDate(String? date) {
    emit(state.copyWith(toDate: date));
  }

  Future<void> workDetails(String projectId) async {
    emit(WorkDetailsLoading());
    try {
      WorkDetailModel response = await HttpServices.getWorkDetails(projectId);
      if (response.status == true) {
        emit(WorkDetailsSuccess(response));
      }
    } catch (e) {
      emit(WorkDetailsFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
