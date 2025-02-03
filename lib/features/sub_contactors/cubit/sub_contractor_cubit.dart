import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/contractorlist/contractor_list_model.dart';
import '../../../data/services/http_services.dart';
import 'sub_contractor_state.dart';

class SubContractorCubit extends Cubit<SubContractorState> {
  SubContractorCubit() : super(SubContractorInitial()){
    getContractorList();
  }
  Future<void> getContractorList() async {
      emit(SubContractorLoading());
      try {
        ContractorListModel response = await HttpServices.getContractorList();
        
        if (response.status == true) {
          emit(SubContractorSuccess(response));
        }
      } catch (e) {
        emit(SubContractorFailure('Failed to fetch data: ${e.toString()}'));
      }
    }
}
