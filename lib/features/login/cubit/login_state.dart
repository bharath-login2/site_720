part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginPasswordVisibilityChanged extends LoginState {
  final bool isObscure;

  LoginPasswordVisibilityChanged(this.isObscure);
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);
}
