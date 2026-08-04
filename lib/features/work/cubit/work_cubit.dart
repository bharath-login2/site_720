import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/work/work_model.dart';
import '../../../data/services/http_services.dart';
import 'work_state.dart';

class WorkCubit extends Cubit<WorkState> {
  WorkCubit() : super(WorkInitial());

  List<ExternalWorkItem> workList = [];

  /// GET WORK LIST
  Future<void> getExternalWorkDetailsList() async {
    emit(WorkLoading());

    try {
      final response = await HttpServices.getExternalWorkDetailsList();

      final model = ExternalWorkModel.fromJson(response);

      if (model.status == true) {
        workList = model.data;

        emit(
          WorkSuccess(
            workList: workList,
            filteredWorkList: workList,
          ),
        );
      } else {
        emit(
          WorkFailure(model.message),
        );
      }
    } catch (e) {
      emit(
        WorkFailure(e.toString()),
      );
    }
  }

  void searchProjects(String query) {
    if (state is WorkSuccess) {
      final currentState = state as WorkSuccess;

      if (query.isEmpty) {
        emit(
          WorkSuccess(
            workList: currentState.workList,
            filteredWorkList: currentState.workList,
          ),
        );
        return;
      }

      final filteredList = currentState.workList.where((item) {
        return item.projectName.toLowerCase().contains(query.toLowerCase());
      }).toList();

      emit(
        WorkSuccess(
          workList: currentState.workList,
          filteredWorkList: filteredList,
        ),
      );
    }
  }
}
