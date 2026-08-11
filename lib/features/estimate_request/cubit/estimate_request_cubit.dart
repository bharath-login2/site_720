import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/http_services.dart';
import '../../../data/models/estimate_request/estimate_request_model.dart';
import '../../../data/models/expenselist/project_id_list_model.dart';
import '../../../data/models/stages/stage_model.dart';
import '../../../data/models/extraworklist/staffListModel.dart';
import 'estimate_request_state.dart';

class EstimateRequestCubit extends Cubit<EstimateRequestState> {
  EstimateRequestCubit() : super(EstimateRequestInitial());

  String? currentProjectId;

  @override
  void onChange(Change<EstimateRequestState> change) {
    super.onChange(change);

    if (change.nextState is EstimateRequestLoaded) {
      final state = change.nextState as EstimateRequestLoaded;
    }
  }

  EstimateRequestResponse response = EstimateRequestResponse(
    status: false,
    message: '',
    data: [],
  );

  /// Project List
  GetProjectIdList? projectResponse;
  List<ProjectIdList> projectList = [];

  /// Stage List
  GetStagesModel? stageResponse;
  List<GetStages> stageList = [];

  StaffListModel? staffResponse;
  List<StaffList> staffList = [];

  Future getEstimateRequests({String? projectId}) async {
    emit(EstimateRequestLoading());

    try {
      // Remember the current filter
      currentProjectId = projectId;

      response = await HttpServices.getEstimateRequests(
        projectId: projectId,
      );

      emit(EstimateRequestLoaded(response));
    } catch (e) {
      print("ERROR = $e");
      emit(EstimateRequestError(e.toString()));
    }
  }

  /// Get Project List
  Future<void> getProjectList() async {
    try {
      projectResponse = await HttpServices.getProjectIdList();
      projectList = projectResponse?.data ?? [];
    } catch (e) {
      emit(
        EstimateRequestError(e.toString()),
      );
    }
  }

  /// Get Stage List
  Future<void> getStageList(String projectId) async {
    try {
      stageResponse = await HttpServices.getStagesList(projectId);
      stageList = stageResponse?.data ?? [];

      emit(EstimateRequestLoaded(response));
    } catch (e) {
      emit(EstimateRequestError(e.toString()));
    }
  }

  // Add Estimate Request
  Future<void> addEstimateRequest({
    required String projectId,
    required String stageId,
    required String remark,
  }) async {
    try {
      await HttpServices.estimateRequestAction(
        requestAction: "add",
        projectId: projectId,
        stageId: stageId,
        remark: remark,
      );

      await getEstimateRequests(
        projectId: currentProjectId,
      );
    } catch (e) {
      emit(
        EstimateRequestError(e.toString()),
      );
    }
  }

  /// Update Estimate Request
  Future<void> updateEstimateRequest({
    required String requestId,
    required String projectId,
    required String stageId,
    required String remark,
  }) async {
    try {
      await HttpServices.estimateRequestAction(
        requestAction: "edit",
        requestId: requestId,
        projectId: projectId,
        stageId: stageId,
        remark: remark,
      );

      await getEstimateRequests(
        projectId: currentProjectId,
      );
    } catch (e) {
      emit(
        EstimateRequestError(e.toString()),
      );
    }
  }

  //delete Estimate Request
  Future<void> deleteEstimateRequest({
    required String requestId,
  }) async {
    try {
      await HttpServices.estimateRequestAction(
        requestAction: "delete",
        requestId: requestId,
      );

      await getEstimateRequests(
        projectId: currentProjectId,
      );
    } catch (e) {
      emit(
        EstimateRequestError(e.toString()),
      );
    }
  }

  //get staff list for approve
  // Currently Approve commented out, but can be enabled if needed
  // Future<void> getStaffList() async {
  //   try {
  //     staffResponse = await HttpServices.getStaffsList();

  //     staffList = staffResponse?.data ?? [];

  //     emit(EstimateRequestLoaded(response));
  //   } catch (e) {
  //     emit(EstimateRequestError(e.toString()));
  //   }
  // }
}
