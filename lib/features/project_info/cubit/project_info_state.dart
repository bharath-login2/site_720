part of 'project_info_cubit.dart';

@immutable
abstract class ProjectInfoState {}

class ProjectInfoInitial extends ProjectInfoState {}

class ProjectInfoLoading extends ProjectInfoState {}

class ProjectInfoSuccess extends ProjectInfoState {
  final ProjectInfoModel response;

  ProjectInfoSuccess(this.response);
}

class ProjectInfoFailure extends ProjectInfoState {
  final String message;

  ProjectInfoFailure(this.message);
}
