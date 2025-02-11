import '../../../data/models/project_list/edit_data_model.dart';
import '../../../data/models/project_list/project_data_model.dart';
import '../../../data/models/project_list/project_list_model.dart';

class ProjectListState {
  final DateTime? fromDate;
  final DateTime? toDate;

  ProjectListState({this.fromDate, this.toDate});

  ProjectListState copyWith({String? fromDate, String? toDate}) {
    return ProjectListState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class ProjectListInitial extends ProjectListState {}

class ProjectListLoading extends ProjectListState {}

class ProjectDataLoading extends ProjectListState {}

class ProjectListSuccess extends ProjectListState {
  final ProjectListModel response;
  ProjectListSuccess(this.response);
}

class ProjectListFailure extends ProjectListState {
  final String message;
  ProjectListFailure(this.message);
}

class PlanSuccess extends ProjectListState {
  final List imageList;
  PlanSuccess(this.imageList);
}

class ElevationSuccess extends ProjectListState {
  final List imageList;
  ElevationSuccess(this.imageList);
}

class ImageFailure extends ProjectListState {
  final String message;
  ImageFailure(this.message);
}

class PriorityUpdated extends ProjectListState {
  final String value;
  PriorityUpdated(this.value);
}

class ProjectDataSuccess extends ProjectListState {
  final ProjectDataModel response;
  ProjectDataSuccess(this.response);
}

class AddProjectSuccess extends ProjectListState {
  final String message;
  AddProjectSuccess(this.message);
}

class AddProjectFailed extends ProjectListState {
  final String message;
  AddProjectFailed(this.message);
}

class EditDtailsSuccess extends ProjectListState {
  final EditDataModel response;
  EditDtailsSuccess(this.response);
}

class EditDtailsLoading extends ProjectListState {
  EditDtailsLoading();
}
class EditProjectSuccess extends ProjectListState {
  final String message;
  EditProjectSuccess(this.message);
}

class EditProjectFailed extends ProjectListState {
  final String message;
  EditProjectFailed(this.message);
}