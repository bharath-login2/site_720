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

  Future<void> getProjectList(String status, String searchKey) async {
    emit(ProjectListLoading());
    try {
      ProjectListModel response =
          await HttpServices.getProjectList(status, searchKey);
      if (response.status == true) {
        emit(ProjectListSuccess(response));
      }
    } catch (e) {
      emit(ProjectListFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> deleteProject(
      String projectId, String status, String searchKey) async {
    try {
      SuccessResponse response = await HttpServices.deleteProject(projectId);
      if (response.status == true) {
        emit(ProjectDeleted(response.message));
        getProjectList(status, searchKey);
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
