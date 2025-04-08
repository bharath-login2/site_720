import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/extraworklist/extra_work_model.dart';
import '../../../data/models/succes_response/success_response.dart';
import '../../../data/services/http_services.dart';
import 'extra_work_state.dart';

class ExtraWorkCubit extends Cubit<ExtraWorkState> {
  ExtraWorkCubit(String projectId) : super(ExtraWorkInitial()) {
    getExtraWorkList(projectId);
  }

  Future<void> getExtraWorkList(String projectId) async {   
    emit(ExtraWorkLoading());
    try {
      ExtraWorkListModel response =
          await HttpServices.getExtraWorkList(projectId);

      if (response.status == true) {
        emit(ExtraWorkSuccess(response));
      } else {
        emit(ExtraWorkFailure('Failed to fetch data}'));
        // emit(ExtraWorkSuccess(response));
      }
    } catch (e) {
      emit(ExtraWorkFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

    Future<void> addExtraWork(
      String projectId,
      String clintId,
      String work,
      String amount,
      String description
    ) async {
    try {
      SuccessResponse response = await HttpServices.addExtraWork(projectId,
          clintId, work, amount, description);
      if (response.status == true) {
        getExtraWorkList(projectId);
        emit(AddedSuccess(response));
      } else {
          emit(AddedFailure(response)); 
      }
    } catch (e) {
       emit(ExtraWorkFailure('Failed to fetch data: ${e.toString()}'));
    }
  }


  Future<void> editExtraWork(
      String projectId,
      String clintId,
    String workId,
      String work,
      String amount,
      String description
    ) async {
    try {
      SuccessResponse response = await HttpServices.editExtraWork(projectId,
          clintId,workId, work, amount, description,);
      if (response.status == true) {
        getExtraWorkList(projectId);
        emit(AddedSuccess(response));
      } else {
          emit(AddedFailure(response)); 
      }
    } catch (e) {
       emit(ExtraWorkFailure('Failed to fetch data: ${e.toString()}'));
    }
  }


  Future<void> deleteExtraWork(
     String projectId,
    String workId,
    
    ) async {
    try {
      SuccessResponse response = await HttpServices.deleteExtraWork(workId);
      if (response.status == true) {
        getExtraWorkList(projectId);
        emit(AddedSuccess(response));
      } else {
          emit(AddedFailure(response)); 
      }
    } catch (e) {
       emit(ExtraWorkFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
