import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/data/models/succes_response/success_response.dart';
import 'package:site_720/data/models/workdetails/work_detail_model.dart';

import '../../../data/models/workdetails/add_work_details_model.dart';
import '../../../data/models/workdetails/work_stage_model.dart';
import '../../../data/services/http_services.dart';
import 'work_details_state.dart';

class WorkDetailsCubit extends Cubit<WorkDetailsState> {
  WorkDetailsCubit(String projectId) : super(WorkDetailsInitial()) {
    getWorkDetails(projectId);
    getWorkIssues();
     getWorkStages(projectId);
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

    Future<void> getWorkStages(String projectId) async {
    try {
      WorkStagesModel response = await HttpServices.getWorkStages(projectId);
      if (response.status == true) {
        emit(WorkStagesSuccess(response));
      } else {
        emit(WorkDetailsFailure(response.message));
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
      String stage,
      String description) async {
    try {
      SuccessResponse response = await HttpServices.addWorkDetails(projectId,
          clintId, isWorking, date, noOfLabours, status, stage, description);
      if (response.status == true) {
        await getWorkDetails(projectId);
        emit(AddingSuccess(response.message.isNotEmpty
            ? response.message
            : "Work detail added successfully"));
      } else {
        emit(AddingFailure(response.message.isNotEmpty
            ? response.message
            : "Failed to add work detail"));
      }
    } catch (e) {
      emit(AddingFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> editWorkDetails(
      String projectId,
      String clintId,
      String isWorking,
      String date,
      String noOfLabours,
      String status,
      String stage,
      String description,
      String workId) async {
    try {
      SuccessResponse response = await HttpServices.editWorkDetails(projectId,
          clintId, isWorking, date, noOfLabours, status, stage, description, workId);
      if (response.status == true) {
        await getWorkDetails(projectId);
        emit(AddingSuccess(response.message.isNotEmpty
            ? response.message
            : "Work detail updated successfully"));
      } else {
        emit(AddingFailure(response.message.isNotEmpty
            ? response.message
            : "Failed to update work detail"));
      }
    } catch (e) {
      emit(AddingFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> deleteWorkDetails(String projectId, String workId) async {
    if (state is WorkDetailsSuccess) {
      final currentResponse = (state as WorkDetailsSuccess).response;
      final updatedList = currentResponse.data
          .where((item) => item.id.toString() != workId.toString())
          .toList();
      emit(WorkDetailsSuccess(WorkDetailModel(
        data: updatedList,
        message: currentResponse.message,
        status: currentResponse.status,
      )));
    }

    try {
      SuccessResponse response = await HttpServices.deleteWorkDetails(workId);
      if (response.status == true) {
        await getWorkDetails(projectId);
        emit(AddingSuccess(response.message.isNotEmpty
            ? response.message
            : "Work detail deleted successfully"));
      } else {
        await getWorkDetails(projectId);
        emit(AddingFailure(response.message.isNotEmpty
            ? response.message
            : "Failed to delete work detail"));
      }
    } catch (e) {
      await getWorkDetails(projectId);
      emit(AddingFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
