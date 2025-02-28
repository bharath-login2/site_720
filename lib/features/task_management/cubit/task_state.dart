import 'package:image_picker/image_picker.dart';

import '../../../data/models/tasklist/task_details_model.dart';
import '../../../data/models/tasklist/task_status.dart';
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

class TaskDetailsSuccess extends TaskState {
  TaskDetailsModel response;
  TaskDetailsSuccess(this.response);
}

class TaskDetailsFailure extends TaskState {
  final String message;
  TaskDetailsFailure(this.message);
}

class TaskStatusSuccess extends TaskState {
  TaskStatusModel response;
  TaskStatusSuccess(this.response);
}

class TaskStatusFailure extends TaskState {
  final String message;
  TaskStatusFailure(this.message);
}
class ImageSuccess extends TaskState {
  final XFile image;
  ImageSuccess(this.image);
}

class ImageFailure extends TaskState {
  final String message;
  ImageFailure(this.message);
}