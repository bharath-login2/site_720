import '../../../data/models/workdetails/add_work_details_model.dart';
import '../../../data/models/workdetails/work_detail_model.dart';
import '../../../data/models/workdetails/work_stage_model.dart';

class WorkDetailsState {
  final DateTime? fromDate;
  final DateTime? toDate;

  WorkDetailsState({this.fromDate, this.toDate});

  WorkDetailsState copyWith({String? fromDate, String? toDate}) {
    return WorkDetailsState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class WorkDetailsInitial extends WorkDetailsState {}

class WorkDetailsLoading extends WorkDetailsState {}

class WorkDetailsSuccess extends WorkDetailsState {
  WorkDetailModel response;

  WorkDetailsSuccess(this.response);
}

class WorkStatusSuccess extends WorkDetailsState {
  AddWorkDetailsModel response;

  WorkStatusSuccess(this.response);
}

class WorkDetailsFailure extends WorkDetailsState {
  final String message;
  WorkDetailsFailure(this.message);
}
class AddingSuccess extends WorkDetailsState {
  final String message;
  AddingSuccess(this.message);
}
class AddingFailure extends WorkDetailsState {
  final String message;
  AddingFailure(this.message);
}

class WorkStagesSuccess extends WorkDetailsState {
  WorkStagesModel response;

  WorkStagesSuccess(this.response);
}
