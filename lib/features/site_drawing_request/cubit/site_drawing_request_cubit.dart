import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/http_services.dart';
import '../../../data/models/site_drawing_request/site_drawing_request_model.dart';
import '../../../data/models/expenselist/project_id_list_model.dart';
import '../../../data/models/stages/stage_model.dart';
import 'site_drawing_request_state.dart';

class SiteDrawingRequestCubit extends Cubit<SiteDrawingRequestState> {
  SiteDrawingRequestCubit() : super(SiteDrawingRequestInitial());

  SiteDrawingRequestListResponse response = SiteDrawingRequestListResponse(
    status: false,
    message: '',
    data: [],
  );

  /// Project List
  GetProjectIdList? projectResponse;
  List projectList = [];

  /// Stage List
  GetStagesModel? stageResponse;
  List stageList = [];

  /// Get Site Drawing Requests
  Future getSiteDrawingRequests() async {
    emit(SiteDrawingRequestLoading());

    try {
      response = await HttpServices.getSiteDrawingRequests();

      emit(SiteDrawingRequestLoaded(response));
    } catch (e) {
      emit(
        SiteDrawingRequestError(e.toString()),
      );
    }
  }

  /// Get Project List
  Future getProjectList() async {
    try {
      projectResponse = await HttpServices.getProjectIdList();

      projectList = projectResponse?.data ?? [];

      emit(
        SiteDrawingRequestLoaded(response),
      );
    } catch (e) {
      emit(
        SiteDrawingRequestError(e.toString()),
      );
    }
  }

  /// Get Stage List
  Future getStageList(String projectId) async {
    try {
      stageResponse = await HttpServices.getStagesList(projectId);

      stageList = stageResponse?.data ?? [];

      emit(
        SiteDrawingRequestLoaded(response),
      );
    } catch (e) {
      emit(
        SiteDrawingRequestError(e.toString()),
      );
    }
  }

  // Add Site Drawing Request
  Future addSiteDrawingRequest({
    required String projectId,
    required List<String> stages,
    required String remark,
  }) async {
    try {
      await HttpServices.saveDrawingRequests(
        projectId: projectId,
        stageId: stages,
        remark: remark,
      );

      await getSiteDrawingRequests();
    } catch (e) {
      emit(
        SiteDrawingRequestError(e.toString()),
      );
    }
  }

  // /// Edit Site Drawing Request
  Future updateSiteDrawingRequest({
    required String requestId,
    required String projectId,
    required List<String> stages,
    required String remark,
  }) async {
    try {
      await HttpServices.siteDrawingUpdate(
        recordId: requestId,
        projectId: projectId,
        stages: stages,
        remark: remark,
      );

      await getSiteDrawingRequests();
    } catch (e) {
      emit(
        SiteDrawingRequestError(e.toString()),
      );
    }
  }

  //Delete
  Future deleteSiteDrawingRequest({
    required String requestId,
  }) async {
    try {
      await HttpServices.deleteDrawingRequests(
        recordId: requestId,
      );

      await getSiteDrawingRequests();
    } catch (e) {
      emit(
        SiteDrawingRequestError(e.toString()),
      );
    }
  }
}
