import '../../../data/models/work_issues/work_issues_model.dart';

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
  WorkIssueListModel response;

  WorkIssuesSuccess(this.response);
}

class WorkIssuesFailure extends WorkIssuesState {
  final String message;
  WorkIssuesFailure(this.message);
}
