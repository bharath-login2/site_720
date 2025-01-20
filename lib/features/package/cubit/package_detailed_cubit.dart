import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/features/package/cubit/package_details_state.dart';



class PackageDetailedCubit extends Cubit<PackageDetailedState> {
  PackageDetailedCubit() : super(PackageDetailedInitial());

  void startLoading() {
    emit(PackageDetailedLoading());
  }

  void emitSuccess(String message) {
    emit(PackageDetailedSuccess(message));
  }

  void emitFailure(String message) {
    emit(PackageDetailedFailure(message));
  }

  void updateFromDate(String? date) {
    emit(state.copyWith(fromDate: date));
  }

  void updateToDate(String? date) {
    emit(state.copyWith(toDate: date));
  }
}
