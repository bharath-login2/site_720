import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/extraworklist/extra_work_model.dart';
import '../../../data/services/http_services.dart';
import 'extra_work_state.dart';

class ExtraWorkCubit extends Cubit<ExtraWorkState> {
  ExtraWorkCubit(String projectId) : super(ExtraWorkInitial()){
    getExtraWorkList( projectId);
  }


  Future<void> getExtraWorkList(String projectId) async {
      emit(ExtraWorkLoading());
      try {
        ExtraWorkListModel response = await HttpServices.getExtraWorkList(projectId);
        
        if (response.status == true) {
          emit(ExtraWorkSuccess(response));
        }else{
        emit(ExtraWorkFailure('Failed to fetch data}'));
        }
      } catch (e) {
        emit(ExtraWorkFailure('Failed to fetch data: ${e.toString()}'));
      }
    }
}
