import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/complaint/complaint_details_model.dart';
import '../../../data/services/http_services.dart';
import 'complaint_state.dart';

class AddComplaintCubit extends Cubit<ComplaintState> {
  AddComplaintCubit() : super(ComplaintInitial()) {
    getComplaintDetails();
  }

  Future<void> getComplaintDetails() async {
    emit(ComplaintLoading());
    try {
      ComplaintDetailsModel response = await HttpServices.getComplaintDetails();

      if (response.status == true) {
        emit(ComplaintDetailsFetched(response));
      }
    } catch (e) {
      emit(ComplaintFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  updateComplaintType(String value) {
    emit(ComplaintTypeUpdated(value));
  }

  updateReportedby(String value) {
    emit(ReportedByUpdated(value));
  }

  updatNature(String value) {
    emit(NatureUpdated(value));
  }

  updateStatus(String value) {
    emit(StatusUpdated(value));
  }
}
