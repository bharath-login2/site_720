import '../../../data/models/estimate_request/estimate_request_model.dart';



abstract class EstimateRequestState {}

class EstimateRequestInitial extends EstimateRequestState {}

class EstimateRequestLoading extends EstimateRequestState {}

class EstimateRequestLoaded extends EstimateRequestState {
  final EstimateRequestResponse response;

  EstimateRequestLoaded(this.response);
}

class EstimateRequestError extends EstimateRequestState {
  final String message;

  EstimateRequestError(this.message);
}