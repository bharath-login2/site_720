import 'package:site_720/data/models/estimate/estimate_model.dart';


abstract class EstimationState {}

class EstimationInitial extends EstimationState {}

class EstimationLoading extends EstimationState {}

class EstimationSuccess extends EstimationState {
  final EstimateModel response;
  EstimationSuccess(this.response);
}

class EstimationFailure extends EstimationState {
  final String message;
  EstimationFailure(this.message);
}
