import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/project_list/project_list_model.dart';
import '../../../data/services/http_services.dart';
import 'project_list_state.dart';

class ProjectListCubit extends Cubit<ProjectListState> {
  ProjectListCubit(String status, String searchKey)
      : super(ProjectListInitial()) {
    getProjectList(status, searchKey);
  }

  Future<void> getProjectList(String status, String searchKey) async {
    emit(ProjectListLoading());
    try {
      ProjectListModel response =
          await HttpServices.getProjectList(status, searchKey);
      if (response.status == true) {
        emit(ProjectListSuccess(response));
      }
    } catch (e) {
      emit(ProjectListFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
