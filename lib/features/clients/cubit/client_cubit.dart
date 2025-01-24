import 'package:flutter_bloc/flutter_bloc.dart';
part 'client_state.dart';

class ClientsCubit extends Cubit<ClientsState> {
  ClientsCubit() : super(ClientInitial());

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
