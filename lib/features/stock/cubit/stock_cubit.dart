import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/stock/stock_list.dart';
import '../../../data/services/http_services.dart';
import 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  StockCubit(String projectId) : super(StockInitial()){
    getStockList(projectId);
  }

   Future<void> getStockList(String projectId) async {
      emit(StockLoading());
      try {
        StockListModel response = await HttpServices.getStockList(projectId);
        
        if (response.status == true) {
          emit(StockSuccess(response));
        }else{
        emit(StockFailure('Failed to fetch data}'));
        }
      } catch (e) {
        emit(StockFailure('Failed to fetch data: ${e.toString()}'));
      }
    }
}
