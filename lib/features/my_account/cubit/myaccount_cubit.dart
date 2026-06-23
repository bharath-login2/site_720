import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/my_account/my_account_model.dart';
import '../../../data/services/http_services.dart';
import 'myaccount_state.dart';

class MyAccountCubit extends Cubit<SalaryLedgerState> {
  MyAccountCubit() : super(const SalaryLedgerInitial()) {
    getMyAccountList();
  }

  Future<void> getMyAccountList() async {
    emit(const SalaryLedgerLoading());

    try {
      final SalaryLedgerResponse? response =
          await HttpServices.getMyAccountList();

      if (response != null && response.status == true) {
        // print("Status: ${response.status}");
        // print("Message: ${response.message}");
        // print("Data: ${response.data}");
        // print("Ledger: ${response.data?.ledger}");
        // print("Ledger Count: ${response.data?.ledger?.length}");

        emit(
          SalaryLedgerSuccess(response),
        );
      } else {
        emit(
          SalaryLedgerFailure(
            response?.message ?? 'Failed to fetch data',
          ),
        );
      }
    } catch (e) {
      emit(
        SalaryLedgerFailure(
          'Failed to fetch data: $e',
        ),
      );
    }
  }
}
