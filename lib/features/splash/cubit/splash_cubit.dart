import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../data/models/version/version_model.dart';
import '../../../data/services/http_services.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial()) {
    getCurrentVersion();
    getVersion();
  }

  String appVersion = '';

  Future<void> getCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
  }

  Future<void> getVersion() async {
    emit(SplashLoading());
    try {
      VersionModel response = await HttpServices.getVersion();
      if (response.status == true) {
        int versionCompare = appVersion.compareTo(response.data);
        if (versionCompare < 0) {
          emit(LowerVersion());
        } else {
          emit(VersionSuccess());
        }
      }
    } catch (e) {
      emit(GetVersionFailed('Failed to fetch data: ${e.toString()}'));
    }
  }
}
