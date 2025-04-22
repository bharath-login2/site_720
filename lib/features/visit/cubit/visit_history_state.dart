import '../../../data/models/visit/visit_history_model.dart';
import '../../../data/models/visit/visit_list_model.dart';

class VisitHistoryState {
  VisitHistoryState();
}

class VisitHistoryInitial extends VisitHistoryState {}

class VisitHistoryLoading extends VisitHistoryState {}

class VisitHistorySuccess extends VisitHistoryState {
  ListVisitModel response;
  VisitHistorySuccess(this.response);
}

class VisitHistoryFailure extends VisitHistoryState {
  final String message;
 VisitHistoryFailure(this.message);
}

class VisitHistoryDetailsSuccess extends VisitHistoryState {
  final VisitHistoryDetailsModel response;
 VisitHistoryDetailsSuccess(this.response);
}

class VisitHistoryDetailsFailure extends VisitHistoryState {
  final String message;
  VisitHistoryDetailsFailure(this.message);
}

class VisitHistoryDetailsSuccessWithMessage extends VisitHistoryState {
  final String message;

  VisitHistoryDetailsSuccessWithMessage(this.message);
}
