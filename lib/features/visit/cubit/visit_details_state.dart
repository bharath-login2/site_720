

import '../../../data/models/visit/visit_details_model.dart';

class VisitDetailsState {
  VisitDetailsState();
}

class VisitDetailInitial extends VisitDetailsState {}

class VisitDetailLoading extends VisitDetailsState {}

class VisitDetailSuccess extends VisitDetailsState {
  ListVisitDetailsModel response;
 VisitDetailSuccess(this.response);
}

class VisitDetailFailure extends VisitDetailsState {
  final String message;
  VisitDetailFailure(this.message);
}

class VisitDetailsSuccess extends VisitDetailsState {
  final ListVisitDetailsModel response;
  VisitDetailsSuccess(this.response);
}


class VisitDetailsFailure extends VisitDetailsState {
  final String message;
  VisitDetailsFailure(this.message);
}

class VisitDetailSuccessWithMessage extends VisitDetailsState {
  final String message;

  VisitDetailSuccessWithMessage(this.message);
}
