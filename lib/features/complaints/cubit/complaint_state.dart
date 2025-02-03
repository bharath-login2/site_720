import '../../../data/models/complaint/complaint_list_model.dart';

class ComplaintState {
  final DateTime? fromDate;
  final DateTime? toDate;

  ComplaintState({this.fromDate, this.toDate});

  ComplaintState copyWith({String? fromDate, String? toDate}) {
    return ComplaintState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class ComplaintInitial extends ComplaintState {
  
}

class ComplaintLoading extends ComplaintState {}

class ComplaintSuccess extends ComplaintState {
   ComplaintListModel response;
  ComplaintSuccess(this.response);
}

class ComplaintFailure extends ComplaintState {
  final String message;
  ComplaintFailure(this.message);
}
