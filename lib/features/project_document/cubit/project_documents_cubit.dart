import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/projectdocument/project_document_model.dart';
import '../../../data/services/http_services.dart';
import 'project_documents_state.dart';

class ProjectDocumentsCubit extends Cubit<ProjectDocumentsState> {
  ProjectDocumentsCubit(String projectId) : super(ProjectDocumentsInitial()) {
    getProjectDocuments(projectId);
  }

  Future<void> getProjectDocuments(String projectId) async {
    emit(ProjectDocumentsLoading());

    try {
      List<ProjectDocument> response = await HttpServices.getProjectDocs(
        projectId: projectId,
      );

      emit(ProjectDocumentsSuccess(response));
    } catch (e) {
      emit(
        ProjectDocumentsFailure(
          'Failed to fetch data: ${e.toString()}',
        ),
      );
    }
  }
}
