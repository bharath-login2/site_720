import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/stages/stage_model.dart';
import '../../../data/services/http_services.dart';
import 'stages_state.dart';

class StagesCubit extends Cubit<StagesState> {
  StagesCubit(String projectId) : super(StagesInitial()) {
    getStagesList(projectId);
  }

  Future<void> getStagesList(String projectId) async {
    emit(StagesLoading());
    try {
      GetStagesModel response = await HttpServices.getStagesList(projectId);

      if (response.status == true) {
        emit(StagesSuccess(response));
      } else {
        emit(StagesFailure('Failed to fetch data}')); 
      }
    } catch (e) {
      emit(StagesFailure('Failed to fetch data: ${e.toString()}'));
    }
  } 
}
