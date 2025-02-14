import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/deductionwork/deductionlist_model.dart';
import '../../../data/models/deductionwork/phaselist_model.dart';
import '../../../data/models/succes_response/success_response.dart';
import '../../../data/services/http_services.dart';
import 'deduction_work_state.dart';

class DeductionWorkCubit extends Cubit<DeductionWorkState> {
  DeductionWorkCubit(String projectId) : super(DeductionWorkInitial()){
    getPhaseList(projectId);
    getDeductionWorkList(projectId);
  }

 Future<void> getDeductionWorkList(String projectId) async {
    emit(DeductionWorkLoading());
    try {
      GetDeductionWork response =
          await HttpServices.getDeductionWorkList(projectId);

      if (response.status == true) {
        emit(DeductionWorkSuccess(response));
      } else {
        emit(DeductionWorkFailure('Failed to fetch data}'));
      }
    } catch (e) {
      emit(DeductionWorkFailure('Failed to fetch data: ${e.toString()}'));
    }
  }


  Future<void> getPhaseList(String projectId) async {
    try {
      PhaseList response =
          await HttpServices.getPhaseList(projectId);
      if (response.status == true) {
        emit(PhaselistSuccess(response));
      } else {
      }
    } catch (e) {
      emit(DeductionWorkFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> addDeductionworkList(
      String projectId,
      String clintId,
      String work,
      selectedStatus,
      String percentage,
      String amount,
      String description
    ) async {
    try {
      SuccessResponse response = await HttpServices.adddeductionWork(projectId,
          clintId, work,selectedStatus, percentage, amount, description);
      if (response.status == true) {
        getDeductionWorkList(projectId);
        emit(AddedSuccess(response));
      } else {
          emit(AddedFailure(response)); 
      }
    } catch (e) {
       emit(DeductionWorkFailure('Failed to fetch data: ${e.toString()}'));
    }
  }


  Future<void> editDeductionworkList(
      String projectId,
      String clintId,
      String workId,
      String work,
      selectedStatus,
      String percentage,
      String amount,
      String description
    ) async {
    try {
      SuccessResponse response = await HttpServices.editdeductionWork(projectId,
          clintId,workId, work,selectedStatus, percentage, amount, description);
      if (response.status == true) {
        getDeductionWorkList(projectId);
        emit(AddedSuccess(response));
      } else {
          emit(AddedFailure(response)); 
      }
    } catch (e) {
       emit(DeductionWorkFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

    Future<void> deleteDeductionWork(
      String projectId,
      String workId,
      ) async {
    try {
      SuccessResponse response = await HttpServices.deletedeductionwork(projectId,
          workId);
      if (response.status == true) {
        getDeductionWorkList(projectId);
        emit(AddedSuccess(response));
      } else {
          emit(AddedFailure(response)); 
      }
    } catch (e) {
       emit(DeductionWorkFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
