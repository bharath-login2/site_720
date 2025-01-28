part of 'forgot_password_cubit.dart';

abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String message;

  ForgotPasswordSuccess(this.message);
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;

  ForgotPasswordFailure(this.message);
}

class OtpSent extends ForgotPasswordState {
  final String message;
  final String otp;

  OtpSent(this.message, this.otp);
}

class ForgotPasswordTimerUpdated extends ForgotPasswordState {
  final int secondsRemaining;
  final bool isResendButtonEnabled;

  ForgotPasswordTimerUpdated(this.secondsRemaining, this.isResendButtonEnabled);
}

class PasswordVisibilityChanged extends ForgotPasswordState {
  final bool isObscure;
  PasswordVisibilityChanged(this.isObscure);
}

class ConfirmPasswordVisibilityChanged extends ForgotPasswordState {
  final bool confirmObscure;
  ConfirmPasswordVisibilityChanged(this.confirmObscure);
}

class OtpVerified extends ForgotPasswordState {}

class OtpVerificationFailed extends ForgotPasswordState {}
