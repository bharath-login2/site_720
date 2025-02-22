import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/stockconsume/stockconsume_model.dart';
import '../../../data/services/http_services.dart';
import 'consumption_state.dart';

class ConsumptionCubit extends Cubit<ConsumptionState> {
  ConsumptionCubit(String projectId) : super(ConsumptionInitial()){
   getConsumeList(projectId); 
  }

  Future<void> getConsumeList(String projectId) async {
    emit(ConsumptionLoading());
    try {
      StockConsumeModel response = await HttpServices.getConsumeList(projectId);

      if (response.status == true) {
        emit(ConsumptionSuccess(response));
      
      } else {
        emit(ConsumptionFailure('Failed to fetch data}'));
      }
    } catch (e) {
      emit(ConsumptionFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
