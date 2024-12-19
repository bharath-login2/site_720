
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void togglePasswordVisibility(bool isObscure) {
    emit(LoginPasswordVisibilityChanged(!isObscure));
  }

  Future<void> login(String username, String password) async {
    emit(LoginLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock response
      final success = username == "admin" && password == "1234";

      if (success) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure("Invalid username or password."));
      }
    } catch (e) {
      emit(LoginFailure("An error occurred."));
    }
  }
}
