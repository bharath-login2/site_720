import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/features/package/cubit/package_state.dart';

import '../../../data/models/package/package_model.dart';
import '../../../data/services/http_services.dart';

class PackageCubit extends Cubit<PackageState> {
  PackageCubit(String projectId) : super(PackageInitial()) {
    getPackage(projectId);
  }

  Future<void> getPackage(String projectId) async {
    emit(PackageLoading());
    try {
      PackageModel response = await HttpServices.getPackage(projectId);

      if (response.status == true) {
        emit(PackageSuccess(response));
      } else {
        emit(PackageFailure('Failed to fetch data}'));
      }
    } catch (e) {
      emit(PackageFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
