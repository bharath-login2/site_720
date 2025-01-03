import 'package:flutter_bloc/flutter_bloc.dart';
part 'add_client_state.dart';

class AddClientCubit extends Cubit<AddClientState> {
  AddClientCubit() : super(AddClientInitial());

  void togglePasswordVisibility(bool isObscure) {
    emit(AddClientPasswordVisibilityChanged(!isObscure));
  }

  Future<void> addClient(String username, String password) async {
    emit(AddClientLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));

      final success = username == "1" && password == "1";

      if (success) {
        emit(AddClientSuccess("Client added"));
      } else {
        emit(AddClientFailure("Failed."));
      }
    } catch (e) {
      emit(AddClientFailure("An error occurred."));
    }
  }
}
