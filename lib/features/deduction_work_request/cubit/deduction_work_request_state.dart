import '../../../data/models/deductionwork_request/deduction_work_request_model.dart';
abstract class DeductionWorkRequestState {}

class DeductionWorkRequestInitial extends DeductionWorkRequestState {}

class DeductionWorkRequestLoading extends DeductionWorkRequestState {}

class DeductionWorkRequestLoaded extends DeductionWorkRequestState {
  final DeductionWorkRequestListResponse response;

  DeductionWorkRequestLoaded(this.response);
}

class DeductionWorkRequestError extends DeductionWorkRequestState {
  final String message;

  DeductionWorkRequestError(this.message);
}
