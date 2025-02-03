import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/complaint/complaint_list_model.dart';
import '../../../data/services/http_services.dart';
import 'complaint_state.dart';

class ComplaintCubit extends Cubit<ComplaintState> {
  ComplaintCubit() : super(ComplaintInitial()){
    getComplaintList();
  }

 
 Future<void> getComplaintList() async {
      emit(ComplaintLoading());
      try {
        ComplaintListModel response = await HttpServices.getComplaintList();
        
        if (response.status == true) {
          emit(ComplaintSuccess(response));
        }
      } catch (e) {
        emit(ComplaintFailure('Failed to fetch data: ${e.toString()}'));
      }
    }
}
