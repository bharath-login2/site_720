// import '../../../data/models/succes_response/success_response.dart';
// import '../../../data/models/visit/visit_details_model.dart';

// class VisitDetailsState {
//   VisitDetailsState();
// }

// class VisitDetailInitial extends VisitDetailsState {}

// class VisitDetailLoading extends VisitDetailsState {}

// class VisitDetailSuccess extends VisitDetailsState {
//   final  ListVisitDetailsModel response;
//  VisitDetailSuccess(this.response);
// }

// class VisitDetailFailure extends VisitDetailsState {
//   final String message;
//   VisitDetailFailure(this.message);
// }

// class VisitDetailsSuccess extends VisitDetailsState {
//   final ListVisitDetailsModel response;
//   VisitDetailsSuccess(this.response);
// }

// class VisitDetailsFailure extends VisitDetailsState {
//   final String message;
//   VisitDetailsFailure(this.message);
// }

// class VisitDetailSuccessWithMessage extends VisitDetailsState {
//   final String message;

//   VisitDetailSuccessWithMessage(this.message);
// }

// class VisitStatusUpdateSuccess extends VisitDetailsState {
//   final SuccessResponse response;
//   VisitStatusUpdateSuccess(this.response);
// }
import '../../../data/models/visit/visit_questions_model.dart';

abstract class VisitTaskState {}

class VisitTaskLoading extends VisitTaskState {}

class VisitTaskLoaded extends VisitTaskState {
  final VisitTaskData data;
  VisitTaskLoaded(this.data);
}

class VisitTaskFailure extends VisitTaskState {
  final String message;
  VisitTaskFailure(this.message);
}

class VisitTaskSaving extends VisitTaskState {}

class VisitTaskSaved extends VisitTaskState {
  final String message;
  VisitTaskSaved(this.message);
}

class VisitTaskSaveFailed extends VisitTaskState {
  final String message;
  VisitTaskSaveFailed(this.message);
}
