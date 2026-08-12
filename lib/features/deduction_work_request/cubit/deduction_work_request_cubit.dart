import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/deductionwork_request/deduction_work_request_model.dart';
import 'deduction_work_request_state.dart';

class DeductionWorkRequestCubit extends Cubit<DeductionWorkRequestState> {
  DeductionWorkRequestCubit() : super(DeductionWorkRequestInitial());

  DeductionWorkRequestListResponse response = DeductionWorkRequestListResponse(
    status: false,
    message: '',
    data: [],
  );
}
