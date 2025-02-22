import '../../../data/models/clientlist/client_list_model.dart';
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
