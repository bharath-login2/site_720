// To parse this JSON data, do
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
  String attachment;
  String updatedDate;

  TaskHistory({
    required this.id,
    required this.taskId,
    required this.reStatus,
    required this.comment,
    required this.attachment,
    required this.updatedDate,
  });

  factory TaskHistory.fromJson(Map<String, dynamic> json) => TaskHistory(
        id: json["id"],
        taskId: json["task_id"],
        reStatus: json["re_status"],
        comment: json["comment"],
        attachment: json["attachment"],
        updatedDate: json["updated_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_id": taskId,
        "re_status": reStatus,
        "comment": comment,
        "attachment": attachment,
        "updated_date": updatedDate,
      };
}
