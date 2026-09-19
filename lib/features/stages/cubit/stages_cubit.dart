import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/stages/stage_model.dart';
import '../../../data/models/stages/stagephase_model.dart';
import '../../../data/models/succes_response/success_response.dart';
import '../../../data/models/stage_list/project_statge_list.dart';
import '../../../data/services/http_services.dart';
import 'stages_state.dart';

class StagesCubit extends Cubit<StagesState> {
  StagesCubit(String projectId) : super(StagesInitial()) {
    getPhaseNew(projectId);
    getStagesList(projectId);
  }

  List<GetStages> items = [];
  List<GetStages> filteredItems = [];
  List<StageData> stageList = [];

  Future<void> getStagesList(String projectId) async {
    emit(StagesLoading());
    try {
      GetStagesModel response = await HttpServices.getStagesList(projectId);

      if (response.status == true) {
        emit(StagesSuccess(response));
        items = response.data;
      } else {
        emit(StagesFailure('Failed to fetch data}'));
      }
    } catch (e) {
      emit(StagesFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> getPhaseNew(String projectId) async {
    try {
      StagePhaseList response = await HttpServices.getPhaseNew(projectId);
      if (response.status == true) {
        emit(PhaselistSuccess(response));
      } else {}
    } catch (e) {
      emit(StagesFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  // Future<void> addStageDetails(
  //     String projectId,
  //     String clintId,
  //     //  selectedStatus,
  //     String stage,
  //     String days,
  //     String curingdays,
  //     String startDateController,
  //     String endDateController) async {
  //   try {
  //     // First check whether the stage already exists
  //     final stageExists = await HttpServices.checkStageName(
  //       projectId: projectId,
  //       clientId: clintId,
  //       stageName: stage,
  //     );

  //     if (stageExists) {
  //       emit(StageNameExists());
  //       return;
  //     }

  //     // Stage doesn't exist, so add it
  //     SuccessResponse response = await HttpServices.addStages(
  //         projectId,
  //         clintId,
  //         // selectedStatus,
  //         stage,
  //         days,
  //         curingdays,
  //         startDateController,
  //         endDateController);
  //     if (response.status == true) {
  //       getStagesList(projectId);
  //       emit(AddedSuccess(response));
  //     } else {
  //       emit(AddedFailure(response));
  //     }
  //   } catch (e) {
  //     emit(StagesFailure('Failed to fetch data: ${e.toString()}'));
  //   }
  // }
  Future<bool> addStageDetails(
      String projectId,
      String clintId,
      //  selectedStatus,
      String stage,
      String days,
      String curingdays,
      String startDateController,
      String endDateController) async {
    try {
      // First check whether the stage already exists
      print("clint id $clintId");
      final stageExists = await HttpServices.checkStageName(
        projectId: projectId,
        clientId: clintId,
        stageName: stage,
      );
      print("ADD STAGE - DUPLICATE RESULT: $stageExists");

      if (stageExists) {
        emit(StageNameExists());
        return false;
      }
      print("ADD STAGE - STAGE DOES NOT EXIST, CALLING ADD API");

      // Stage doesn't exist, so add it
      SuccessResponse response = await HttpServices.addStages(
          projectId,
          clintId,
          // selectedStatus,
          stage,
          days,
          curingdays,
          startDateController,
          endDateController);
      if (response.status == true) {
        getStagesList(projectId);
        emit(AddedSuccess(response));
        return true;
      } else {
        emit(AddedFailure(response));
        return false;
      }
    } catch (e) {
      emit(StagesFailure('Failed to fetch data: ${e.toString()}'));
      return false;
    }
  }

  Future<void> editStageDetails(
      String projectId,
      String clintId,
      String stageId,
      //  selectedStatus,
      String stage,
      String estDays,
      String curingdays,
      String startDateController,
      String endDateController) async {
    try {
      SuccessResponse response = await HttpServices.editStages(
          projectId,
          clintId,
          stageId,
          // selectedStatus,
          stage,
          estDays,
          curingdays,
          startDateController,
          endDateController);
      if (response.status == true) {
        getStagesList(projectId);
        emit(AddedSuccess(response));
      } else {
        emit(AddedFailure(response));
      }
    } catch (e) {
      emit(StagesFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  void filterSearch(String query) {
    filteredItems = items
        .where((item) =>
            item.stageName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(SearchResult(filteredItems));
  }

  Future<void> getStageList(String projectId) async {
    try {
      final response = await HttpServices.getStageList(
        projectId: projectId,
      );

      if (response != null && response.status == true) {
        stageList = response.data;
      } else {
        stageList = [];
      }
    } catch (e) {
      stageList = [];
    }
  }

  Future<bool> addFirstScheduleDate({
    required String stageId,
    required String projectId,
    required String scheduleDate,
  }) async {
    try {
      final response = await HttpServices.addFirstScheduleDate(
        stageId: stageId,
        projectId: projectId,
        scheduleDate: scheduleDate,
      );

      if (response != null && response["status"] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
