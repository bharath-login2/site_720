import '../../../data/models/extraworklist/extra_work_model.dart';
import '../../../data/models/succes_response/success_response.dart';

class ExtraWorkState {
  final DateTime? fromDate;
  final DateTime? toDate;

  ExtraWorkState({this.fromDate, this.toDate});

  ExtraWorkState copyWith({String? fromDate, String? toDate}) {
    return ExtraWorkState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class ExtraWorkInitial extends ExtraWorkState {
  
}

class ExtraWorkLoading extends ExtraWorkState {}

class ExtraWorkSuccess extends ExtraWorkState {
    ExtraWorkListModel response;
  ExtraWorkSuccess(this.response);
}

class ExtraWorkFailure extends ExtraWorkState {
  final String message;
  ExtraWorkFailure(this.message);
}

class AddedSuccess extends ExtraWorkState {
  SuccessResponse  response;
  AddedSuccess(this.response);
}

class AddedFailure extends ExtraWorkState {
  SuccessResponse  response;
  AddedFailure(this.response);
}
