import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/installment/installment_model.dart';
import '../../../data/services/http_services.dart';
import 'installment_state.dart';

class InstallmentCubit extends Cubit<InstallmentState> {
  InstallmentCubit() : super(const InstallmentInitial());

  Future<void> getInstallments(String projectId) async {
    emit(const InstallmentLoading());

    try {
      final InstallmentModel? response =
          await HttpServices.getInstallments(projectId);

      if (response != null) {
        emit(
          InstallmentLoaded(response.data),
        );
      } else {
        emit(
          const InstallmentError(
            "No data found",
          ),
        );
      }
    } catch (e) {
      emit(
        InstallmentError(
          e.toString(),
        ),
      );
    }
  }
}
