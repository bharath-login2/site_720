import 'package:image_picker/image_picker.dart';
import 'package:site_720/data/models/succes_response/success_response.dart';

import '../../../data/models/complaint/complaint_history_model.dart';
import '../../../data/models/task/task_history.dart';

class ComplaintHistoryState {
  ComplaintHistoryState();
}

class ComplaintHistoryInitial extends ComplaintHistoryState {}

class ComplaintHistoryLoading extends ComplaintHistoryState {}

class ComplaintHistorySuccess extends ComplaintHistoryState {
  ComplaintHistoryModel response;
 ComplaintHistorySuccess(this.response);
}

class ComplaintHistoryFailure extends ComplaintHistoryState {
  final String message;
  ComplaintHistoryFailure(this.message);
}

class ComplaintHistoryDetailsSuccess extends ComplaintHistoryState {
ComplaintHistoryModel response;
  ComplaintHistoryDetailsSuccess(this.response);
}

class ComplaintHistoryDetailsFailure extends ComplaintHistoryState {
  final String message;
  ComplaintHistoryDetailsFailure(this.message);
}


class ImageHistorySuccess extends ComplaintHistoryState {
  final XFile image;
  ImageHistorySuccess(this.image);
}

class ImageFailure extends ComplaintHistoryState {
  final String message;
  ImageFailure(this.message);
}

class ComplaintHistoryStatusUpdated extends ComplaintHistoryState {
  SuccessResponse response;
  ComplaintHistoryStatusUpdated(this.response);
}
class ComplaintHistoryStatusupdateFailed extends ComplaintHistoryState {
  final String message;
  ComplaintHistoryStatusupdateFailed(this.message);
}
class AttendanceUpdated extends ComplaintHistoryState {
  SuccessResponse response;
  AttendanceUpdated(this.response);
}

class AttendanceFailed extends ComplaintHistoryState {
  final String message;
  AttendanceFailed(this.message);
}

class PopupLoading extends ComplaintHistoryState {}

class HistoryLoading extends ComplaintHistoryState {}

class HistoryFetched extends ComplaintHistoryState {
  TaskHistoryModel response;
  HistoryFetched(this.response);
}

class FileUploadSuccess extends ComplaintHistoryState {
  final String filePath;
  FileUploadSuccess(this.filePath);
}

class FileUploadFailure extends ComplaintHistoryState {
  final String message;
  FileUploadFailure(this.message);
}

class ComplaintHistoryDetailsSuccessWithMessage extends ComplaintHistoryState {
  final String message;

  ComplaintHistoryDetailsSuccessWithMessage(this.message);
}


