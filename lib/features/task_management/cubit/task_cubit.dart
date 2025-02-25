import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial()) {
    getTaskList();
  }

  Future<void> getTaskList() async {
    // emit(TaskLoading());
    try {
      // TaskListModel response = await HttpServices.getTaskList(projectId);

      // if (response.status == true) {
      //   emit(TaskSuccess(response));
      // }else{
      // emit(TaskFailure('Failed to fetch data}'));
      // }
    } catch (e) {
      emit(TaskFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
