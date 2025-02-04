import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/data/models/succes_response/success_response.dart';
import 'package:site_720/data/models/workdetails/work_detail_model.dart';

import '../../../data/models/workdetails/add_work_details_model.dart';
import '../../../data/services/http_services.dart';
import 'work_details_state.dart';

class WorkDetailsCubit extends Cubit<WorkDetailsState> {
  WorkDetailsCubit(String projectId) : super(WorkDetailsInitial()) {
    getWorkDetails(projectId);
    getWorkIssues();
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

  Future<void> getWorkDetails(String projectId) async {
    emit(WorkDetailsLoading());
    try {
      WorkDetailModel response = await HttpServices.getWorkDetails(projectId);
      if (response.status == true) {
        emit(WorkDetailsSuccess(response));
      } else {
        emit(WorkDetailsFailure(response.message));
      }
    } catch (e) {
      emit(WorkDetailsFailure('Failed to fetch data: ${e.toString()}')); 
    }
  }

  Future<void> getWorkIssues() async {
    try {
      AddWorkDetailsModel response = await HttpServices.getWorkIssues();
      if (response.status == true) {
        emit(WorkStatusSuccess(response));
      }
    } catch (e) {
      emit(WorkDetailsFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> addWorkDetails(
      String projectId,
      String clintId,
      String isWorking,
      String date,
      String noOfLabours,
      String status,
      String description) async {
    try {
      SuccessResponse response = await HttpServices.addWorkDetails(projectId,
          clintId, isWorking, date, noOfLabours, status, description);
      if (response.status == true) {
        getWorkDetails(projectId);
        emit(AddingSuccess(response.message));
      } else {
        emit(AddingFailure(response.message));
      }
    } catch (e) {
      emit(AddingFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
