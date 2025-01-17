import 'package:flutter_bloc/flutter_bloc.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  void togglePasswordVisibility(bool isObscure) {
    emit(ForgotPasswordPasswordVisibilityChanged(!isObscure));
  }

  Future<void> sendOtp(String username) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      final success = username == "1";

      if (success) {
        emit(ForgotPasswordSuccess("ForgotPassword success"));
      } else {
        emit(ForgotPasswordFailure("Invalid username or password."));
      }
    } catch (e) {
      emit(ForgotPasswordFailure("An error occurred."));
    }
  }
}
