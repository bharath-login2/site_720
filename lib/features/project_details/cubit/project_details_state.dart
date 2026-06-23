import '../../../data/models/project_details/project_detais_model.dart';

class ProjectDetailsState {}

class ProjectDetailsInitial extends ProjectDetailsState {}

class ProjectDetailsLoading extends ProjectDetailsState {}

class ProjectDetailsSuccess extends ProjectDetailsState {
  final ProjectDetailsModel response;
  ProjectDetailsSuccess(this.response);
}

class ProjectDetailsFailure extends ProjectDetailsState {
  final String message;
  ProjectDetailsFailure(this.message);
}
