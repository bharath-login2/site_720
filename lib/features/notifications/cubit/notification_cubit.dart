import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<Map<String, dynamic>> {
  NotificationCubit() : super({});

  void updateNotification(Map<String, dynamic> notificationData) {
    emit(notificationData);
  }

  void setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        String data = message.data.toString();
        data = data.replaceAllMapped(RegExp(r'(\w+):'), (match) => '"${match[1]}":');
        data = data.replaceAllMapped(RegExp(r':\s([\w\s]+)'), (match) => ': "${match[1]}"');
        Map<String, dynamic> employeeData = jsonDecode(data);

        log("Received notification: ${message.notification?.title}");
        updateNotification(employeeData);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log('App opened from a notification!');
        log('Message data: ${message.data}');
      });
    } else {
      log('User declined or has not granted permission');
    }

  }
}
