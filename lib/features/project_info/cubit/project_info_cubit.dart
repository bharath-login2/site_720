import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/project_info/project_info_model.dart';
import '../../../data/services/http_services.dart';

part 'project_info_state.dart';

class ProjectInfoCubit extends Cubit<ProjectInfoState> {
  ProjectInfoCubit() : super(ProjectInfoInitial());

  Future<void> getProjectInfo(String projectId) async {
    emit(ProjectInfoLoading());

    try {
      final response = await HttpServices.getProjectInfo(
        projectId: projectId,
      );

      if (response != null && response.status) {
        emit(ProjectInfoSuccess(response));
      } else {
        emit(
          ProjectInfoFailure(
            response?.message ?? "Something went wrong",
          ),
        );
      }
    } catch (e) {
      emit(ProjectInfoFailure(e.toString()));
    }
  }

  void refresh(String projectId) {
    getProjectInfo(projectId);
  }
}
