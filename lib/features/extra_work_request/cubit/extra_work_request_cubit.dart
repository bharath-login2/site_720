import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/http_services.dart';
import '../../../data/models/extrawork_Request/extra_work_request_model.dart';
import '../../../data/models/projectListRequest/projectListRequestModel.dart';

import 'extra_work_request_state.dart';

class ExtraWorkRequestCubit extends Cubit<ExtraWorkRequestState> {
  ExtraWorkRequestCubit() : super(ExtraWorkRequestInitial());

  String? currentProjectId;

  ExtraWorkRequestListResponse response =
      ExtraWorkRequestListResponse(
    status: false,
    message: '',
    data: [],
  );

  /// Shared Project List
  WorkRequestProjectResponse? projectResponse;
  List<WorkRequestProject> projectList = [];

  // ============================================================
  // GET EXTRA WORK REQUESTS
  // ============================================================

  Future<void> getExtraWorkRequests({
    String? projectId,
  }) async {
    emit(ExtraWorkRequestLoading());

    try {
      currentProjectId = projectId;

      response = await HttpServices.getExtraWorkRequests(
        projectId: projectId,
      );

      emit(
        ExtraWorkRequestLoaded(response),
      );
    } catch (e) {
      print("EXTRA WORK REQUEST CUBIT ERROR: $e");

      emit(
        ExtraWorkRequestError(e.toString()),
      );
    }
  }

  // ============================================================
  // GET PROJECT LIST
  // ============================================================

  Future<void> getProjectList() async {
    try {
      projectResponse =
          await HttpServices.getWorkRequestProjects();

      projectList = projectResponse?.data ?? [];

      print(
        "WORK REQUEST PROJECT COUNT: ${projectList.length}",
      );
    } catch (e) {
      print(
        "GET WORK REQUEST PROJECT LIST ERROR: $e",
      );

      emit(
        ExtraWorkRequestError(e.toString()),
      );
    }
  }

  // ============================================================
  // ADD EXTRA WORK REQUEST
  // ============================================================

  Future<SaveExtraWorkRequestResponse?>
      addExtraWorkRequest({
    required String projectId,
    required List<ExtraWorkItem> items,
  }) async {
    emit(ExtraWorkRequestSubmitting());

    try {
      final requestData = items.map((item) {
        return {
          "item_name": item.itemName,
          "qty": item.qty,
          "remarks": item.remarks,
        };
      }).toList();

      final encodedRequestData =
          jsonEncode(requestData);

      print(
        "========== ADD EXTRA WORK REQUEST ==========",
      );
      print("PROJECT ID   : $projectId");
      print("REQUEST DATA : $encodedRequestData");
      print(
        "============================================",
      );

      final saveResponse =
          await HttpServices.saveExtraWorkRequest(
        projectId: projectId,
        requestData: encodedRequestData,
      );

      if (saveResponse != null &&
          saveResponse.status == true) {
        emit(
          ExtraWorkRequestActionSuccess(
            saveResponse.message.isNotEmpty
                ? saveResponse.message
                : "Request sent.",
          ),
        );
      }

      // Refresh list after adding
      await getExtraWorkRequests(
        projectId: currentProjectId ?? projectId,
      );

      return saveResponse;
    } catch (e) {
      print(
        "ADD EXTRA WORK REQUEST ERROR: $e",
      );

      emit(
        ExtraWorkRequestError(e.toString()),
      );

      rethrow;
    }
  }

  // ============================================================
  // UPDATE EXTRA WORK REQUEST
  // ============================================================

  Future<SaveExtraWorkRequestResponse?>
      updateExtraWorkRequest({
    required String requestId,
    required String itemName,
    required String qty,
    String remarks = '',
  }) async {
    emit(ExtraWorkRequestSubmitting());

    try {
      final updateResponse =
          await HttpServices.updateExtraWorkRequest(
        requestId: requestId,
        itemName: itemName,
        qty: qty,
        remarks: remarks,
      );

      if (updateResponse != null &&
          updateResponse.status == true) {
        emit(
          ExtraWorkRequestActionSuccess(
            updateResponse.message.isNotEmpty
                ? updateResponse.message
                : "Request updated successfully.",
          ),
        );
      }

      // Refresh current project list
      await getExtraWorkRequests(
        projectId: currentProjectId ?? '',
      );

      return updateResponse;
    } catch (e) {
      print(
        "UPDATE EXTRA WORK REQUEST ERROR: $e",
      );

      emit(
        ExtraWorkRequestError(e.toString()),
      );

      rethrow;
    }
  }

  // ============================================================
  // DELETE EXTRA WORK REQUEST
  // ============================================================

  Future<void> deleteExtraWorkRequest({
    required String requestId,
  }) async {
    try {
      await HttpServices.deleteExtraWorkRequest(
        requestId: requestId,
      );

      // Refresh current project list
      await getExtraWorkRequests(
        projectId: currentProjectId,
      );
    } catch (e) {
      print(
        "DELETE EXTRA WORK REQUEST ERROR: $e",
      );

      emit(
        ExtraWorkRequestError(e.toString()),
      );
    }
  }
}