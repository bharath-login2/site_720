part of 'forgot_password_cubit.dart';

abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordPasswordVisibilityChanged extends ForgotPasswordState {
  final bool isObscure;

  ForgotPasswordPasswordVisibilityChanged(this.isObscure);
}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String message;
  ForgotPasswordSuccess(this.message);
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;

  ForgotPasswordFailure(this.message);
}
