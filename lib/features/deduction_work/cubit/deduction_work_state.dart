import '../../../data/models/deductionwork/deductionlist_model.dart';
import '../../../data/models/deductionwork/phaselist_model.dart';
import '../../../data/models/succes_response/success_response.dart';

class DeductionWorkState {
  final DateTime? fromDate;
  final DateTime? toDate;

  DeductionWorkState({this.fromDate, this.toDate});

  DeductionWorkState copyWith({String? fromDate, String? toDate}) {
    return DeductionWorkState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class DeductionWorkInitial extends DeductionWorkState {
  
}

class DeductionWorkLoading extends DeductionWorkState {}

class DeductionWorkSuccess extends DeductionWorkState {
  GetDeductionWork response;
  DeductionWorkSuccess(this.response);
}

class DeductionWorkFailure extends DeductionWorkState {
  final String message;
  DeductionWorkFailure(this.message);
}
class PhaselistSuccess extends DeductionWorkState {
  PhaseList response;
  PhaselistSuccess(this.response);
}

class AddedSuccess extends DeductionWorkState {
  SuccessResponse  response;
  AddedSuccess(this.response);
}

class AddedFailure extends DeductionWorkState {
  SuccessResponse  response;
  AddedFailure(this.response);
}
