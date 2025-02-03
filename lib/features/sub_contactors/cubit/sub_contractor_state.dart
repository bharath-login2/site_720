import '../../../data/models/contractorlist/contractor_list_model.dart';

class SubContractorState {
  final DateTime? fromDate;
  final DateTime? toDate;

  SubContractorState({this.fromDate, this.toDate});

  SubContractorState copyWith({String? fromDate, String? toDate}) {
    return SubContractorState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class SubContractorInitial extends SubContractorState {
  
}

class SubContractorLoading extends SubContractorState {}

class SubContractorSuccess extends SubContractorState {
   ContractorListModel response;
  SubContractorSuccess(this.response);
}

class SubContractorFailure extends SubContractorState {
  final String message;
  SubContractorFailure(this.message);
}
