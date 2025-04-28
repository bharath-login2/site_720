import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utilities/shared_preferences.dart';
import '../../../data/models/login/api_auth.dart';
import '../../../data/models/login/login_model.dart';
import '../../../data/services/http_services.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial()) {
    apiAuth();
  }

  List<Server> serverList = [];
  Server? selectedServer;

  void togglePasswordVisibility(bool isObscure) {
    emit(LoginPasswordVisibilityChanged(!isObscure));
  }

  Future<void> apiAuth() async {
    try {
      ApiAuth response = await HttpServices.apiAuth();
      if (response.status == true) {
        serverList = response.data.server;
        if (serverList.length < 2) {
          selectedServer = serverList[0];
          saveSharedPreference("url", serverList[0].url);
        }
        emit(ServerSuccess(response.message));
      } else {
        emit(ServerFailed(response.message));
      }
    } catch (e) {
      emit(ServerFailed('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> login(String username, String password) async {
    emit(LoginLoading());
    //FirebaseMessaging messaging = FirebaseMessaging.instance;
   // String? firebaseToken = await messaging.getToken();
   String? firebaseToken = 'mock_token';
    log("FCM Token: $firebaseToken");
    try {
      LoginModel response =
          await HttpServices.login(username, password, firebaseToken);
      if (response.status == true) {
        emit(LoginSuccess(response.message, response.data.token));
      } else {
        emit(LoginFailure(response.message));
      }
    } catch (e) {
      emit(LoginFailure("An error occurred."));
    }
  }

//   Future<void> login(String username, String password) async {
//   emit(LoginLoading());
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   try {
//     final settings = await messaging.requestPermission();

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       // ✅ Get APNS Token (iOS only)
//       if (Platform.isIOS) {
//         String? apnsToken = await messaging.getAPNSToken();
//         log("📱 APNS Token: $apnsToken");
//       }

//       // Retry logic for FCM token
//       String? firebaseToken;
//       int retry = 0;
//       const maxRetry = 10;
//       const delay = Duration(seconds: 1);

//       while (firebaseToken == null && retry < maxRetry) {
//         firebaseToken = await messaging.getToken();
//       }

//       if (firebaseToken == null) {
//         emit(LoginFailure("Unable to retrieve FCM token. Please try again."));
//         return;
//       }

//       log("✅ FCM Token: $firebaseToken");

//       final response = await HttpServices.login(username, password, firebaseToken);
//       if (response.status == true) {
//         emit(LoginSuccess(response.message, response.data.token));
//       } else {
//         emit(LoginFailure(response.message));
//       }
//     } else {
//       emit(LoginFailure("Notification permissions not granted."));
//     }
//   } catch (e) {
//     log("❌ Login error: $e");
//     emit(LoginFailure("An error occurred."));
//   }
// }


}
