import '../../../data/models/expenselist/project_id_list_model.dart';

abstract class ProjectState {
  const ProjectState();
}

class ProjectInitial extends ProjectState {
  const ProjectInitial();
}

class ProjectLoading extends ProjectState {
  const ProjectLoading();
}

class ProjectSuccess extends ProjectState {
  final List<ProjectIdList> projects;

  const ProjectSuccess(
    this.projects,
  );
}

class ProjectFailure extends ProjectState {
  final String message;

  const ProjectFailure(
    this.message,
  );
}