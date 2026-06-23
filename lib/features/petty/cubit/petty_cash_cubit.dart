import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/pettycash/petty_cash_model.dart';
import '../../../data/services/http_services.dart';
import 'petty_cash_state.dart';

class PettyCashCubit extends Cubit<PettyCashState> {
  PettyCashCubit() : super(const PettyCashInitial()) {
    getPettyCashLedger();
  }

  Future<void> getPettyCashLedger() async {
    emit(const PettyCashLoading());

    try {
      final PettyCashResponse? response =
          await HttpServices.getPettyCashLedger();

      if (response != null && response.status == true) {
        emit(
          PettyCashSuccess(response),
        );
      } else {
        emit(
          PettyCashFailure(
            response?.message ?? "No records found",
          ),
        );
      }
    } catch (e) {
      emit(
        PettyCashFailure(
          e.toString(),
        ),
      );
    }
  }
}
