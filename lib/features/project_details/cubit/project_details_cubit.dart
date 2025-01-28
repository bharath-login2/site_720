import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/project_details/project_detais_model.dart';
import '../../../data/services/http_services.dart';
import 'project_details_state.dart';

class ProjectDetailsCubit extends Cubit<ProjectDetailsState> {
  ProjectDetailsCubit(String projectId) : super(ProjectDetailsInitial()) {
    getProjectDetails(projectId);
  }



  Future<void> getProjectDetails(String projectId) async {
    emit(ProjectDetailsLoading());
    try {
      ProjectDetailsModel response = await HttpServices.getProjectDetails(projectId);
      if (response.status == true) {
        emit(ProjectDetailsSuccess(response));
      }
    } catch (e) {
      emit(ProjectDetailsFailure('Failed to fetch data: ${e.toString()}')); 
    }
  }
 
 
}
