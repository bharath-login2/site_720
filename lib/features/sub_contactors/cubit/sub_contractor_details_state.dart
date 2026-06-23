import '../../../data/models/subcontractdetails/subcontract_details_model.dart';

abstract class SubContractorDetailsState {}

class SubContractorDetailsLoading
    extends SubContractorDetailsState {}

class SubContractorDetailsSuccess
    extends SubContractorDetailsState {
  final SubContractDetailsModel response;

  SubContractorDetailsSuccess(this.response);
}

class SubContractorDetailsFailure
    extends SubContractorDetailsState {
  final String message;

  SubContractorDetailsFailure(this.message);
}