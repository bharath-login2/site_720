import '../../../data/models/complaint/complaint_details_model.dart';
import '../../../data/models/complaint/complaint_list_model.dart';

class ComplaintState {
  ComplaintState();
}

class ComplaintInitial extends ComplaintState {}

class ComplaintLoading extends ComplaintState {}

class ComplaintSuccess extends ComplaintState {
  ComplaintListModel response;
  ComplaintSuccess(this.response);
}

class ComplaintFailure extends ComplaintState {
  final String message;
  ComplaintFailure(this.message);
}

class ComplaintTypeUpdated extends ComplaintState {
  final String value;
  ComplaintTypeUpdated(this.value);
}

class ComplaintDetailsFetched extends ComplaintState {
  final ComplaintDetailsModel response;
  ComplaintDetailsFetched(this.response);
}
