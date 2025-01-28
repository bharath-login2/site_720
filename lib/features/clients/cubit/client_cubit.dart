import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/clientlist/client_list_model.dart';
import '../../../data/services/http_services.dart';
part 'client_state.dart';

class ClientsCubit extends Cubit<ClientsState> {
  ClientsCubit() : super(ClientInitial()){
    getClientList();
  }

  Future<void> addClient(String username, String password) async {
    emit(AddClientLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));

      final success = username == "1" && password == "1";

      if (success) {
        emit(AddClientSuccess("Client added"));
      } else {
        emit(AddClientFailure("Failed."));
      }
    } catch (e) {
      emit(AddClientFailure("An error occurred."));
    }
  }
  Future<void> getClientList() async {
      emit(ClientDetailsLoading());
      try {
        ClientListModel response = await HttpServices.getClientList();
        
        if (response.status == true) {
          emit(ClientDetailsSuccess(response));
        }
      } catch (e) {
        emit(ClientDetailsFailure('Failed to fetch data: ${e.toString()}'));
      }
    }

}
