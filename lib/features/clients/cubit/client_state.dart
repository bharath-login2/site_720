
import '../../../data/models/clientlist/client_details.dart';
import '../../../data/models/clientlist/client_list_model.dart';
import '../../../data/models/clientlist/client_type_list.dart';
import '../../../data/models/clientlist/district_list.dart';
import '../../../data/models/clientlist/state_list_model.dart';

abstract class ClientsState {}

class ClientInitial extends ClientsState {}

class AddClientLoading extends ClientsState {}

class AddClientSuccess extends ClientsState {
  final String message;
  AddClientSuccess(this.message);
}

class AddClientFailure extends ClientsState {
  final String message;
  AddClientFailure(this.message);
}

class ClientDetailsSuccess extends ClientsState {
  ClientListModel response;
  ClientDetailsSuccess(this.response);
}

class ClientDetailsFailure extends ClientsState {
  final String message;
  ClientDetailsFailure(this.message);
}

class ClientDetailsLoading extends ClientsState {
  ClientDetailsLoading();
}

class StateListFetched extends ClientsState {
  StateListModel response;
  StateListFetched(this.response);
}

class DistrictListFetched extends ClientsState {
  DistrictListModel response;
  DistrictListFetched(this.response);
}

class ClientTypesFetched extends ClientsState {
  ClientTypeListModel response;
  ClientTypesFetched(this.response);
}

class EditClientSuccess extends ClientsState {
  String message;
  EditClientSuccess(this.message);
}

class EditClientFailure extends ClientsState {
  String message;
  EditClientFailure(this.message);
}

class EditDetailsSuccess extends ClientsState {
  ClientDetailsModel response;
  EditDetailsSuccess(this.response);
}

class EditDetailsFailure extends ClientsState {
  String message;
  EditDetailsFailure(this.message);
}

class SearchResult extends ClientsState {
     List<Clients> filteredList;
  SearchResult(this.filteredList);
}
