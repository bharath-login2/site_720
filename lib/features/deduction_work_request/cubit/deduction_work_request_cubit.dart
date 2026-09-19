import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/http_services.dart';
import '../../../data/models/deductionwork_request/deduction_work_request_model.dart';
import '../../../data/models/projectListRequest/projectListRequestModel.dart';
import 'deduction_work_request_state.dart';

class DeductionWorkRequestCubit extends Cubit<DeductionWorkRequestState> {
  DeductionWorkRequestCubit() : super(DeductionWorkRequestInitial());

  String? currentProjectId;

  DeductionWorkRequestListResponse response = DeductionWorkRequestListResponse(
    status: false,
    message: '',
    data: [],
  );

  /// Shared Project List (reused from WorkRequestProject)
  WorkRequestProjectResponse? projectResponse;
  List<WorkRequestProject> projectList = [];

  // ============================================================
  // GET DEDUCTION WORK REQUESTS
  // ============================================================

  Future<void> getDeductionWorkRequests({
    required String projectId,
  }) async {
    emit(DeductionWorkRequestLoading());

    try {
      currentProjectId = projectId;

      response = await HttpServices.getDeductionWorkRequests(
        projectId: projectId,
      );

      emit(
        DeductionWorkRequestLoaded(response),
      );
    } catch (e) {
      print("DEDUCTION WORK REQUEST CUBIT ERROR: $e");

      emit(
        DeductionWorkRequestError(e.toString()),
      );
    }
  }

  // ============================================================
  // GET PROJECT LIST
  // ============================================================

  Future<void> getProjectList() async {
    try {
      projectResponse = await HttpServices.getWorkRequestProjects();

      projectList = projectResponse?.data ?? [];

      print(
        "DEDUCTION WORK REQUEST PROJECT COUNT: ${projectList.length}",
      );
    } catch (e) {
      print(
        "GET DEDUCTION WORK REQUEST PROJECT LIST ERROR: $e",
      );

      emit(
        DeductionWorkRequestError(e.toString()),
      );
    }
  }

  // ============================================================
  // ADD DEDUCTION WORK REQUEST
  // ============================================================

  Future<SaveDeductionWorkRequestResponse?> addDeductionWorkRequest({
    required String projectId,
    required List<DeductionWorkItem> items,
  }) async {
    emit(DeductionWorkRequestSubmitting());

    try {
      final requestData = items.map((item) {
        return {
          "item_name": item.itemName,
          "qty": item.qty,
          "remarks": item.remarks,
        };
      }).toList();

      final encodedRequestData = jsonEncode(requestData);

      print(
        "========== ADD DEDUCTION WORK REQUEST ==========",
      );
      print("PROJECT ID   : $projectId");
      print("REQUEST DATA : $encodedRequestData");
      print(
        "================================================",
      );

      final saveResponse = await HttpServices.saveDeductionWorkRequest(
        projectId: projectId,
        requestData: encodedRequestData,
      );

      if (saveResponse != null && saveResponse.status == true) {
        emit(
          DeductionWorkRequestActionSuccess(
            saveResponse.message.isNotEmpty
                ? saveResponse.message
                : "Request sent.",
          ),
        );
      }

      // Refresh list after adding
      await getDeductionWorkRequests(
        projectId: currentProjectId ?? projectId,
      );

      return saveResponse;
    } catch (e) {
      print(
        "ADD DEDUCTION WORK REQUEST ERROR: $e",
      );

      emit(
        DeductionWorkRequestError(e.toString()),
      );

      rethrow;
    }
  }

  // ============================================================
  // UPDATE DEDUCTION WORK REQUEST
  // ============================================================

  Future<SaveDeductionWorkRequestResponse?> updateDeductionWorkRequest({
    required String requestId,
    required String itemName,
    required String qty,
    String remarks = '',
  }) async {
    emit(DeductionWorkRequestSubmitting());

    try {
      final updateResponse = await HttpServices.updateDeductionWorkRequest(
        requestId: requestId,
        itemName: itemName,
        qty: qty,
        remarks: remarks,
      );

      if (updateResponse != null && updateResponse.status == true) {
        emit(
          DeductionWorkRequestActionSuccess(
            updateResponse.message.isNotEmpty
                ? updateResponse.message
                : "Request updated successfully.",
          ),
        );
      }

      // Refresh current project list
      await getDeductionWorkRequests(
        projectId: currentProjectId ?? '',
      );

      return updateResponse;
    } catch (e) {
      print(
        "UPDATE DEDUCTION WORK REQUEST ERROR: $e",
      );

      emit(
        DeductionWorkRequestError(e.toString()),
      );

      rethrow;
    }
  }

//delete
  Future<void> deleteDeductionWorkRequest({
    required String requestId,
  }) async {
    try {
      await HttpServices.deleteDeductionWorkRequest(
        requestId: requestId,
      );

      // Refresh current project list
      await getDeductionWorkRequests(
        projectId: currentProjectId ?? '',
      );
    } catch (e) {
      print(
        "DELETE DEDUCTION WORK REQUEST ERROR: $e",
      );

      emit(
        DeductionWorkRequestError(e.toString()),
      );
    }
  }
}
