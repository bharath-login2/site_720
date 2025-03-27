import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/clientlist/client_list_model.dart';
import '../../../data/services/http_services.dart';
import 'client_state.dart';

class ClientsCubit extends Cubit<ClientsState> {
  ClientsCubit() : super(ClientInitial()) {
    getClientList();
  }

  List<Clients> items = [];
  List<Clients> filteredItems = [];

  Future<void> getClientList() async {
    emit(ClientDetailsLoading());
    try {
      ClientListModel response = await HttpServices.getClientList();

      if (response.status == true) {
        items = response.data;
        filterSearch("");
      }
    } catch (e) {
      emit(ClientDetailsFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  void filterSearch(String query) {
    filteredItems = items
        .where((item) =>
            item.clientName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(SearchResult(filteredItems));
  }
}
