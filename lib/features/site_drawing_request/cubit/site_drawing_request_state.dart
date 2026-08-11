import "../../../data/models/site_drawing_request/site_drawing_request_model.dart";

abstract class SiteDrawingRequestState {}

class SiteDrawingRequestInitial extends SiteDrawingRequestState {}

class SiteDrawingRequestLoading extends SiteDrawingRequestState {}

class SiteDrawingRequestLoaded extends SiteDrawingRequestState {
  final SiteDrawingRequestListResponse response;

  SiteDrawingRequestLoaded(this.response);
}

class SiteDrawingRequestError extends SiteDrawingRequestState {
  final String message;

  SiteDrawingRequestError(this.message);
}
