// To parse this JSON data, do
//
//     final notificationListModel = notificationListModelFromJson(jsonString);

import 'dart:convert';

NotificationListModel notificationListModelFromJson(String str) => NotificationListModel.fromJson(json.decode(str));

String notificationListModelToJson(NotificationListModel data) => json.encode(data.toJson());

class NotificationListModel {
    List<NotificationData> data;
    String message;
    bool status;

    NotificationListModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory NotificationListModel.fromJson(Map<String, dynamic> json) => NotificationListModel(
        data: List<NotificationData>.from(json["data"].map((x) => NotificationData.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class NotificationData {
    int id;
    String title;
    String message;
    DateTime timestamp;

    NotificationData({
        required this.id,
        required this.title,
        required this.message,
        required this.timestamp,
    });

    factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
        id: json["id"],
        title: json["title"],
        message: json["message"],
        timestamp: DateTime.parse(json["timestamp"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "message": message,
        "timestamp": timestamp.toIso8601String(),
    };
}
