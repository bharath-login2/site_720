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

          await saveSharedPreference(
            "url",
            serverList[0].url,
          );
        }

        emit(ServerSuccess(response.message));
      } else {
        emit(ServerFailed(response.message));
      }
    } catch (e) {
      emit(
        ServerFailed(
          'Failed to fetch data: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> login(
    String username,
    String password,
  ) async {
    emit(LoginLoading());

    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      /// REQUEST PERMISSION
      await messaging.requestPermission();

      /// GET FCM TOKEN
      String firebaseToken = "";

      try {
        firebaseToken = await messaging.getToken() ?? "";
      } catch (e) {
        log("FCM TOKEN ERROR : $e");
      }

      /// IOS APNS TOKEN
      if (Platform.isIOS) {
        try {
          String? apnsToken = await messaging.getAPNSToken();
          log("APNS TOKEN : $apnsToken");
        } catch (e) {
          log("APNS TOKEN ERROR : $e");
        }
      }

      log("FCM TOKEN : $firebaseToken");

      /// CHECK SAVED PIN
      String savedPin = await getSharedPreference("user_pin") ?? "";

      log("SAVED PIN : $savedPin");

      /// LOGIN API
      final response = await HttpServices.login(
        username,
        password,
        firebaseToken,
      );

      if (response.status == true) {
        /// SAVE LOGIN DETAILS AGAIN
        /// SO PIN WILL NOT BECOME EMPTY AFTER LOGOUT

        await saveSharedPreference(
          "username",
          username,
        );

        await saveSharedPreference(
          "password",
          password,
        );

        /// KEEP PIN SAFE
        if (savedPin.isNotEmpty) {
          await saveSharedPreference(
            "user_pin",
            savedPin,
          );

          await saveSharedPreference(
            "is_pin_set",
            "true",
          );
        }

        emit(
          LoginSuccess(
            response.message,
            response.data.token,
          ),
        );
      } else {
        emit(
          LoginFailure(
            response.message,
          ),
        );
      }
    } catch (e, stacktrace) {
      log("LOGIN ERROR : $e");
      log(stacktrace.toString());

      emit(
        LoginFailure(
          "Login Failed",
        ),
      );
    }
  }
}
