
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

class ProjectListInitial extends ProjectListState {
  
}

class ProjectListLoading extends ProjectListState {}

class ProjectListSuccess extends ProjectListState {
  final ProjectListModel  response;
  ProjectListSuccess(this.response);
}

class ProjectListFailure extends ProjectListState {
  final String message;
  ProjectListFailure(this.message);
}

class ImageSuccess extends ProjectListState {
  final List imageList;
  ImageSuccess(this.imageList);
}

class ImageFailure extends ProjectListState {
  final String message;
  ImageFailure(this.message);
}
