import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/login/login_model.dart';
import '../../../data/services/http_services.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void togglePasswordVisibility(bool isObscure) {
    emit(LoginPasswordVisibilityChanged(!isObscure));
  }

  Future<void> login(String username, String password) async {
    emit(LoginLoading());
    try {
      LoginModel response = await HttpServices.login(username, password, "");
      if (response.status == true) {
        emit(LoginSuccess(response.message, response.data.token));
      } else {
        emit(LoginFailure(response.message));
      }
    } catch (e) {
      emit(LoginFailure("An error occurred."));
    }
  }
}
