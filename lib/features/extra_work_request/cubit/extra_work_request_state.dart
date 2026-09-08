import '../../../data/models/extrawork_Request/extra_work_request_model.dart';

abstract class ExtraWorkRequestState {}

class ExtraWorkRequestInitial extends ExtraWorkRequestState {}

class ExtraWorkRequestLoading extends ExtraWorkRequestState {}

class ExtraWorkRequestLoaded extends ExtraWorkRequestState {
  final ExtraWorkRequestListResponse response;

  ExtraWorkRequestLoaded(this.response);
}

class ExtraWorkRequestError extends ExtraWorkRequestState {
  final String message;

  ExtraWorkRequestError(this.message);
}

class ExtraWorkRequestSubmitting extends ExtraWorkRequestState {}

class ExtraWorkRequestActionSuccess extends ExtraWorkRequestState {
  final String message;

  ExtraWorkRequestActionSuccess(this.message);
}
