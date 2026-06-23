import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/contractorlist/contractor_list_model.dart';
import '../../../data/services/http_services.dart';
import 'sub_contractor_state.dart';

class SubContractorCubit extends Cubit<SubContractorState> {
  final String projectId;
  SubContractorCubit(this.projectId) : super(SubContractorInitial()) {
    getContractorList();
  }

  Future<void> getContractorList() async {
    emit(SubContractorLoading());
    try {
      ContractorListModel response =
          await HttpServices.getSubContractorList(projectId);

      if (response.status == true) {
        emit(SubContractorSuccess(response));
      } else {
        emit(SubContractorFailure('No contractors found'));
      }
    } catch (e) {
      emit(SubContractorFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
