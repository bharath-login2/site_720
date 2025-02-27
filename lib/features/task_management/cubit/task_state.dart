
import '../../../data/models/tasklist/tasklist_model.dart';

class TaskState {
  TaskState();
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskSuccess extends TaskState {
  GetTaskList response;
  TaskSuccess(this.response);
}

class TaskFailure extends TaskState {
  final String message;
  TaskFailure(this.message);
}
