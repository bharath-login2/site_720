import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/features/package/cubit/package_details_state.dart';

import '../../../data/models/package/package_model.dart';
import '../../../data/services/http_services.dart';



class PackageDetailedCubit extends Cubit<PackageDetailedState> {
  PackageDetailedCubit(String projectId) : super(PackageDetailedInitial()){
    getPackageList(projectId);
  }

 Future<void> getPackageList(String projectId) async {
    emit(PackageDetailedLoading());
    try {
      GetPackageList response =
          await HttpServices.getPackageList(projectId);

      if (response.status == true) {
        emit(PackageDetailedSuccess(response));
      } else {
        emit(PackageDetailedFailure('Failed to fetch data}'));
        // emit(ExtraWorkSuccess(response));
      }
    } catch (e) {
      emit(PackageDetailedFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
