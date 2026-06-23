import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/paymentschedule/payment_schedule_model.dart';
import '../../../data/services/http_services.dart';
import 'payment_schedule_state.dart';

class PaymentScheduleCubit extends Cubit<PaymentScheduleState> {
  PaymentScheduleCubit() : super(const PaymentScheduleInitial());

  Future<void> getPaymentSchedule(String projectId) async {
    print("PaymentScheduleCubit Called");
    print("Project ID: $projectId");

    emit(const PaymentScheduleLoading());

    try {
      final PaymentScheduleModel? response =
          await HttpServices.getPaymentSchedule(projectId);

      print("Response Object: $response");

      if (response != null) {
        print("Records Count: ${response.data.length}");

        emit(PaymentScheduleLoaded(response.data));
      } else {
        print("Response is NULL");

        emit(const PaymentScheduleError("No data found"));
      }
    } catch (e) {
      print("Cubit Error: $e");

      emit(PaymentScheduleError(e.toString()));
    }
  }
}
