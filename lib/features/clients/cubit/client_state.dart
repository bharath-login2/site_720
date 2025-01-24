part of 'client_cubit.dart';

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
