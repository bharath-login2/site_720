import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/http_services.dart';
import '../../../data/models/site_drawing_request/site_drawing_request_model.dart';
import '../../../data/models/projectListRequest/projectListRequestModel.dart';
import '../../../data/models/stage_list/project_statge_list.dart';
import 'site_drawing_request_state.dart';

class SiteDrawingRequestCubit extends Cubit<SiteDrawingRequestState> {
  SiteDrawingRequestCubit() : super(SiteDrawingRequestInitial());

  SiteDrawingRequestListResponse response = SiteDrawingRequestListResponse(
    status: false,
    message: '',
    data: [],
  );

  /// Project List
  WorkRequestProjectResponse? projectResponse;
  List<WorkRequestProject> projectList = [];

  /// Stage List
  List<StageData> stageList = [];
  // GetStagesModel? stageResponse;
  // List stageList = [];

  int currentPage = 1;
  static const int pageSize = 20;

  bool isLoadingMore = false;
  bool hasMoreRequests = true;

  /// Get Site Drawing Requests
  Future<void> getSiteDrawingRequests({
    int page = 1,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (isLoadingMore || !hasMoreRequests) return;

      isLoadingMore = true;
    } else {
      currentPage = page;
      hasMoreRequests = true;

      emit(SiteDrawingRequestLoading());
    }

    try {
      final newResponse = await HttpServices.getSiteDrawingRequests(
        page: page,
        pageSize: pageSize,
      );

      if (isLoadMore) {
        response.data.addAll(newResponse.data);

        if (newResponse.data.length < pageSize) {
          hasMoreRequests = false;
        }

        currentPage = page;

        emit(SiteDrawingRequestLoaded(response));
      } else {
        response = newResponse;

        if (newResponse.data.length < pageSize) {
          hasMoreRequests = false;
        }

        currentPage = page;

        emit(SiteDrawingRequestLoaded(response));
      }
    } catch (e) {
      emit(
        SiteDrawingRequestError(e.toString()),
      );
    } finally {
      isLoadingMore = false;
    }
  }

  /// Get Project List
  Future<void> getProjectList() async {
    try {
      projectResponse = await HttpServices.getWorkRequestProjects();

      projectList = projectResponse?.data ?? [];

      print(
        "WORK REQUEST PROJECT COUNT: ${projectList.length}",
      );

      emit(
        SiteDrawingRequestLoaded(response),
      );
    } catch (e) {
      print(
        "GET WORK REQUEST PROJECT LIST ERROR: $e",
      );

      emit(
        SiteDrawingRequestError(e.toString()),
      );
    }
  }

  /// Get Stage List
  Future<void> getStageList(String projectId) async {
    try {
      final response = await HttpServices.getStageList(
        projectId: projectId,
      );

      if (response != null && response.status == true) {
        stageList = response.data;
      } else {
        stageList = [];
      }
    } catch (e) {
      stageList = [];
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

      await getSiteDrawingRequests(
        page: 1,
      );
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

      await getSiteDrawingRequests(
        page: 1,
      );
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

      await getSiteDrawingRequests(
        page: 1,
      );
    } catch (e) {
      emit(
        SiteDrawingRequestError(e.toString()),
      );
    }
  }
}
