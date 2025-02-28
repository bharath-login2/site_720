// To parse this JSON data, do
//
//     final taskStatusModel = taskStatusModelFromJson(jsonString);

import 'dart:convert';

TaskStatusModel taskStatusModelFromJson(String str) => TaskStatusModel.fromJson(json.decode(str));

String taskStatusModelToJson(TaskStatusModel data) => json.encode(data.toJson());

class TaskStatusModel {
    Data data;
    String message;
    bool status;

    TaskStatusModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory TaskStatusModel.fromJson(Map<String, dynamic> json) => TaskStatusModel(
        data: Data.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
    };
}

class Data {
    bool status;
    String message;
    List<AvailableStatus> availableStatuses;

    Data({
        required this.status,
        required this.message,
        required this.availableStatuses,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        message: json["message"],
        availableStatuses: List<AvailableStatus>.from(json["available_statuses"].map((x) => AvailableStatus.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "available_statuses": List<dynamic>.from(availableStatuses.map((x) => x.toJson())),
    };
}

class AvailableStatus {
    int id;
    String status;

    AvailableStatus({
        required this.id,
        required this.status,
    });

    factory AvailableStatus.fromJson(Map<String, dynamic> json) => AvailableStatus(
        id: json["id"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
    };
}
