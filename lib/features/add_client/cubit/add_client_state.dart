part of 'add_client_cubit.dart';

abstract class AddClientState {}

class AddClientInitial extends AddClientState {}

class AddClientPasswordVisibilityChanged extends AddClientState {
  final bool isObscure;

  AddClientPasswordVisibilityChanged(this.isObscure);
}

class AddClientLoading extends AddClientState {}

class AddClientSuccess extends AddClientState {
  final String message;
  AddClientSuccess(this.message);
}

class AddClientFailure extends AddClientState {
  final String message;

  AddClientFailure(this.message);
}
