import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/data/models/succes_response/success_response.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/project_list/project_list_model.dart';
import '../../../data/services/http_services.dart';
import 'project_list_state.dart';

class ProjectListCubit extends Cubit<ProjectListState> {
  ProjectListCubit(String status, String searchKey)
      : super(ProjectListInitial()) {
    getProjectList(status, searchKey);
  }
  int currentPage = 1;
  static const int pageSize = 20;

  bool isLoadingMore = false;
  bool hasMoreProjects = true;

  Future<void> getProjectList(
    String status,
    String searchKey, {
    int page = 1,
    int pageSize = 20,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (isLoadingMore || !hasMoreProjects) return;

      isLoadingMore = true;
    } else {
      currentPage = 1;
      hasMoreProjects = true;

      emit(ProjectListLoading());
    }

    try {
      final response = await HttpServices.getProjectList(
        status,
        searchKey,
        page: page,
        pageSize: pageSize,
      );

      if (response.status == true) {
        final newProjects = response.data.projectList;

        if (isLoadMore && state is ProjectListSuccess) {
          final oldResponse = (state as ProjectListSuccess).response;

          oldResponse.data.projectList.addAll(newProjects);
          print(
              "TOTAL PROJECTS IN LIST: ${oldResponse.data.projectList.length}");

          emit(ProjectListSuccess(oldResponse));
        } else {
          emit(ProjectListSuccess(response));
        }

        currentPage = page;

        // Check only the newly received page
        if (newProjects.length < pageSize) {
          hasMoreProjects = false;
        }
      }
    } catch (e) {
      emit(
        ProjectListFailure(
          'Failed to fetch data: ${e.toString()}',
        ),
      );
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> deleteProject(
      String projectId, String status, String searchKey) async {
    try {
      SuccessResponse response = await HttpServices.deleteProject(projectId);
      if (response.status == true) {
        emit(ProjectDeleted(response.message));
        getProjectList(
          status,
          searchKey,
          page: 1,
          pageSize: pageSize,
        );
      }
    } catch (e) {
      emit(ProjectListFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> launchPdfUrl(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the PDF.')),
      );
    }
  }

  Future<void> getPrintPdf(String projectId, BuildContext context) async {
    final result = await HttpServices.getPrintPdf(projectId);
    if (result != null && result.status) {
      launchPdfUrl(result.pdfUrl, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result?.message ?? 'Failed to load PDF')),
      );
    }
  }
}
