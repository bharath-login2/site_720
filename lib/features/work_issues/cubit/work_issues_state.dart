import '../../../data/models/workdetails/add_work_details_model.dart';
import '../../../data/models/workdetails/work_detail_model.dart';

class WorkIssuesState {
  final DateTime? fromDate;
  final DateTime? toDate;

  WorkIssuesState({this.fromDate, this.toDate});

  WorkIssuesState copyWith({String? fromDate, String? toDate}) {
    return WorkIssuesState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class WorkIssuesInitial extends WorkIssuesState {}

class WorkIssuesLoading extends WorkIssuesState {}

class WorkIssuesSuccess extends WorkIssuesState {
  WorkDetailModel response;

  WorkIssuesSuccess(this.response);
}

class WorkIssuesFailure extends WorkIssuesState {
  final String message;
  WorkIssuesFailure(this.message);
}

