import '../../../data/models/projectdocument/project_document_model.dart';

abstract class ProjectDocumentsState {}

class ProjectDocumentsInitial extends ProjectDocumentsState {}

class ProjectDocumentsLoading extends ProjectDocumentsState {}

class ProjectDocumentsSuccess extends ProjectDocumentsState {
  final List<ProjectDocument> documents;

  ProjectDocumentsSuccess(this.documents);
}

class ProjectDocumentsFailure extends ProjectDocumentsState {
  final String error;

  ProjectDocumentsFailure(this.error);
}
