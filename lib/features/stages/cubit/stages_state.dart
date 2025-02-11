
import 'package:site_720/data/models/succes_response/success_response.dart';

import '../../../data/models/stages/stage_model.dart';

class StagesState {
  final DateTime? fromDate;
  final DateTime? toDate;

  StagesState({this.fromDate, this.toDate});

  StagesState copyWith({String? fromDate, String? toDate}) {
    return StagesState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class StagesInitial extends StagesState {
  
}

class StagesLoading extends StagesState {}

class StagesSuccess extends StagesState {
   GetStagesModel response;
  StagesSuccess(this.response);
}

class AddedSuccess extends StagesState {
  SuccessResponse  response;
  AddedSuccess(this.response);
}

class AddedFailure extends StagesState {
  SuccessResponse  response;
  AddedFailure(this.response);
}

class StagesFailure extends StagesState {
  final String message;
  StagesFailure(this.message);
}
