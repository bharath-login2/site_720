import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/expenselist/project_id_list_model.dart';
import '../../../data/services/http_services.dart';
import 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit() : super(const ProjectInitial()) {
    getProjects();
  }

  Future<void> getProjects() async {
    emit(const ProjectLoading());

    try {
      GetProjectIdList response = await HttpServices.getProjectIdList();

      if (response.status == true) {
        emit(
          ProjectSuccess(response.data),
        );
      } else {
        emit(
          const ProjectFailure(
            "Failed to fetch projects",
          ),
        );
      }
    } catch (e) {
      emit(
        ProjectFailure(
          e.toString(),
        ),
      );
    }
  }
}
