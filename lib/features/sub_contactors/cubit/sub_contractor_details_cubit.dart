import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/http_services.dart';
import 'sub_contractor_details_state.dart';

class SubContractorDetailsCubit
    extends Cubit<SubContractorDetailsState> {

  final String contractorId;
  final String workId;

  SubContractorDetailsCubit(
    this.contractorId,
    this.workId,
  ) : super(SubContractorDetailsLoading()) {
    getDetails();
  }

  Future<void> getDetails() async {
    emit(SubContractorDetailsLoading());

    try {
      final response =
          await HttpServices.viewSubcontractWork(
        contractorId: contractorId,
        workId: workId,
      );

      if (response != null && response.status) {
        emit(SubContractorDetailsSuccess(response));
      } else {
        emit(
          SubContractorDetailsFailure(
            response?.message ?? "No details found",
          ),
        );
      }
    } catch (e) {
      emit(
        SubContractorDetailsFailure(e.toString()),
      );
    }
  }
}