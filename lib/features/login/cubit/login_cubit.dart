import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utilities/shared_preferences.dart';
import '../../../data/models/login/api_auth.dart';
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

  // Future<void> login(String username, String password) async {
  //   emit(LoginLoading());
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   String? firebaseToken = await messaging.getToken();
  //  //String? firebaseToken = 'mock_token';
  //   log("FCM Token: $firebaseToken");
  //   try {
  //     LoginModel response =
  //         await HttpServices.login(username, password, firebaseToken);
  //     if (response.status == true) {
  //       emit(LoginSuccess(response.message, response.data.token));
  //     } else {
  //       emit(LoginFailure(response.message));
  //     }
  //   } catch (e) {
  //     emit(LoginFailure("An error occurred."));
  //   }
  // }

 Future<void> login(String username, String password) async {
  emit(LoginLoading());
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  try {
    // Request notification permission
    final settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("✅ User granted permission");

      // Optional: Wait for APNS token (iOS only, if needed)
      if (Platform.isIOS) {
        String? apnsToken;
        int retry = 0;
        const maxRetry = 10;
        const delay = Duration(seconds: 1);

        while (apnsToken == null && retry < maxRetry) {
          apnsToken = await messaging.getAPNSToken();
        }

        if (apnsToken != null) {
          log("📱 APNS Token: $apnsToken");
        } else {
          log("⚠️ APNS Token still null after retries");
          // Optional: you may choose to emit failure here if APNS is critical
        }
      }

      // Retry logic for FCM token
      String? firebaseToken;
      int retry = 0;
      const maxRetry = 10;
      const delay = Duration(seconds: 1);

      while (firebaseToken == null && retry < maxRetry) {
        firebaseToken = await messaging.getToken();
      }

      if (firebaseToken == null) {
        emit(LoginFailure("Unable to retrieve FCM token. Please try again."));
        return;
      }

      log("✅ FCM Token: $firebaseToken");

      // Perform API login
      final response = await HttpServices.login(username, password, firebaseToken);

      if (response.status == true) {
        emit(LoginSuccess(response.message, response.data.token));
      } else {
        emit(LoginFailure(response.message));
      }
    } else {
      emit(LoginFailure("Notification permissions not granted."));
    }
  } catch (e, stacktrace) {
    log("❌ Login error: $e");
    log(stacktrace.toString());
    emit(LoginFailure("An error occurred during login."));
  }
}



}
