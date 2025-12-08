// To parse this JSON data:
//
//     final taskHistoryModel = taskHistoryModelFromJson(jsonString);

import 'dart:convert';

TaskHistoryModel taskHistoryModelFromJson(String str) =>
    TaskHistoryModel.fromJson(json.decode(str));

String taskHistoryModelToJson(TaskHistoryModel data) =>
    json.encode(data.toJson());

class TaskHistoryModel {
  List<TaskHistory> data;
  String message;
  bool status;

  TaskHistoryModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory TaskHistoryModel.fromJson(Map<String, dynamic> json) =>
      TaskHistoryModel(
        data: List<TaskHistory>.from(
            json["data"].map((x) => TaskHistory.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class TaskHistory {
  String id;
  String taskId;
  String reStatus;
  String comment;
  String viewMode;
  List<String> attachments;
  String? historyTitle; // Make this nullable
  String updatedDate;
  String statusName;

  TaskHistory({
    required this.id,
    required this.taskId,
    required this.reStatus,
    required this.comment,
    required this.viewMode,
    required this.attachments,
    this.historyTitle, // Now nullable
    required this.updatedDate,
    required this.statusName,
  });

  factory TaskHistory.fromJson(Map<String, dynamic> json) => TaskHistory(
        id: json["id"] ?? "",
        taskId: json["task_id"] ?? "",
        reStatus: json["re_status"] ?? "",
        comment: json["comment"] ?? "",
        viewMode: json["view_mode"] ?? "",
        attachments: json["attachments"] == null
            ? []
            : List<String>.from(json["attachments"].map((x) => x)),
        historyTitle: json["history_title"], // Can be null
        updatedDate: json["updated_date"] ?? "",
        statusName: json["status_name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_id": taskId,
        "re_status": reStatus,
        "comment": comment,
        "view_mode": viewMode,
        "attachments": List<dynamic>.from(attachments.map((x) => x)),
        "history_title": historyTitle,
        "updated_date": updatedDate,
        "status_name": statusName,
      };
}