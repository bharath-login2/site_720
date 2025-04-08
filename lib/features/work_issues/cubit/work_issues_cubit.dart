import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/work_issues/work_issues_model.dart';
import '../../../data/services/http_services.dart';
import 'work_issues_state.dart';

class WorkIssuesCubit extends Cubit<WorkIssuesState> {
  WorkIssuesCubit(String statusId) : super(WorkIssuesInitial()) {
    getWorkIssues(statusId);
  }

  Future<void> getWorkIssues(String statusId) async {
    emit(WorkIssuesLoading());
    try {
      WorkIssueListModel response =
          await HttpServices.getWorkIssuesList(statusId);
      if (response.status == true) {
        emit(WorkIssuesSuccess(response));
      } else {
        emit(WorkIssuesFailure(response.message));
      }
    } catch (e) {
      emit(WorkIssuesFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
