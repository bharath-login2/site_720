import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/data/services/http_services.dart';
import 'estimation_state.dart';

class EstimationCubit extends Cubit<EstimationState> {
  EstimationCubit(String projectId) : super(EstimationInitial()) {
    getEstimateList(projectId);
  }

  Future<void> getEstimateList(String projectId) async {
    emit(EstimationLoading());
    try {
      final response = await HttpServices.getEstimateList(projectId);
      if (response != null && response.status) {
        emit(EstimationSuccess(response));
      } else {
        emit(EstimationFailure("No data found"));
      }
    } catch (e) {
      emit(EstimationFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
