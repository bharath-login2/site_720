import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/task/task_history.dart';
import '../../../data/services/http_services.dart';
import 'task_state.dart';

class TaskHistoryCubit extends Cubit<TaskState> {
  TaskHistoryCubit(String taskId) : super(TaskInitial()) {
    getTaskHistory(taskId);
  }

  List<TaskHistory> taskList = [];

  Future<void> getTaskHistory(String taskId) async {
    emit(TaskLoading());
    try {
      TaskHistoryModel response = await HttpServices.getTaskHistory(taskId);

      if (response.status == true) {
        emit(HistoryFetched(response));
        taskList = response.data;
      } else {
        emit(TaskFailure('Failed to fetch data}'));
      }
    } catch (e) {
      emit(TaskFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
