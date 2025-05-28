import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../data/models/version/version_model.dart';
import '../../../data/services/http_services.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  String appVersion = '';

  Future<void> checkVersion() async {
    emit(SplashLoading());
    try {
      // Get local app version first
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version;

      // Now fetch remote version
      VersionModel response = await HttpServices.getVersion();
      if (response.status == true) {
        int versionCompare = appVersion.compareTo(response.data);
        if (versionCompare < 0) {
          emit(LowerVersion());
        } else {
          emit(VersionSuccess());
        }
      } else {
        emit(GetVersionFailed('Invalid response from server.'));
      }
    } catch (e) {
      emit(GetVersionFailed('Failed to fetch data: ${e.toString()}'));
    }
  }
   

}
