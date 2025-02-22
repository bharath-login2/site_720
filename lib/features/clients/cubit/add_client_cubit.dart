import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/clientlist/state_list_model.dart';
import '../../../data/services/http_services.dart';
import 'client_state.dart';

class AddClientsCubit extends Cubit<ClientsState> {
  AddClientsCubit() : super(ClientInitial()) {
    getStates();
  }

  Future<void> getStates() async {
    emit(ClientDetailsLoading());
    try {
      StateListModel response = await HttpServices.getStates();

      if (response.status == true) {
        emit(StateListFetched(response));
      }
    } catch (e) {
      emit(ClientDetailsFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
