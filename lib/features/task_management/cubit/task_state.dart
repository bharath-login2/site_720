import 'package:image_picker/image_picker.dart';
import 'package:site_720/data/models/succes_response/success_response.dart';

import '../../../data/models/task/milestoneModel.dart';
import '../../../data/models/task/task_details_model.dart';
import '../../../data/models/task/task_history.dart';
import '../../../data/models/task/task_status.dart';
import '../../../data/models/task/tasklist_model.dart';

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

class TaskStatusUpdated extends TaskState {
  SuccessResponse response;
  TaskStatusUpdated(this.response);
}
class TaskStatusupdateFailed extends TaskState {
  final String message;
  TaskStatusupdateFailed(this.message);
}
class AttendanceUpdated extends TaskState {
  SuccessResponse response;
  AttendanceUpdated(this.response);
}

class AttendanceFailed extends TaskState {
  final String message;
  AttendanceFailed(this.message);
}

class PopupLoading extends TaskState {}

class HistoryLoading extends TaskState {}

class HistoryFetched extends TaskState {
  TaskHistoryModel response;
  HistoryFetched(this.response);
}

class FileUploadSuccess extends TaskState {
  final String filePath;
  FileUploadSuccess(this.filePath);
}

class FileUploadFailure extends TaskState {
  final String message;
  FileUploadFailure(this.message);
}

class TaskDetailsSuccessWithMessage extends TaskState {
  final String message;

  TaskDetailsSuccessWithMessage(this.message);
}
class TaskMilestoneSuccess extends TaskState {
  final MilestoneModel response;

  TaskMilestoneSuccess(this.response);
}


class TaskMilestoneUpdated extends TaskState {
  final String message;

  TaskMilestoneUpdated(this.message);
}

class TaskMilestoneUpdateFailed extends TaskState {
  final String message;

  TaskMilestoneUpdateFailed(this.message);
}


