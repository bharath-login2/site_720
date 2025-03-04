// To parse this JSON data, do
//
//     final taskDetailsModel = taskDetailsModelFromJson(jsonString);

import 'dart:convert';

TaskDetailsModel taskDetailsModelFromJson(String str) => TaskDetailsModel.fromJson(json.decode(str));

String taskDetailsModelToJson(TaskDetailsModel data) => json.encode(data.toJson());

class TaskDetailsModel {
    TaskDetailsData data;
    String message;
    bool status;

    TaskDetailsModel({
        required this.data,
        required this.message,
        required this.status, 
    });

    factory TaskDetailsModel.fromJson(Map<String, dynamic> json) => TaskDetailsModel(
        data: TaskDetailsData.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
    };
}

class TaskDetailsData {
    String id;
    String taskTitle;
    String fromDate;
    String toDate;
    String description;
    String location;
    String priority;
    String status;
    String workType;
    String stageName;
    List<String> attachments;

    TaskDetailsData({
        required this.id,
        required this.taskTitle,
        required this.fromDate,
        required this.toDate,
        required this.description,
        required this.location,
        required this.priority,
        required this.status,
        required this.workType,
        required this.stageName,
        required this.attachments,
    });

    factory TaskDetailsData.fromJson(Map<String, dynamic> json) => TaskDetailsData(
        id: json["id"],
        taskTitle: json["task_title"],
        fromDate: json["from_date"],
        toDate: json["to_date"],
        description: json["description"],
        location: json["location"],
        priority: json["priority"],
        status: json["status"],
        workType: json["work_type"],
        stageName: json["stage_name"],
        attachments: List<String>.from(json["attachments"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "task_title": taskTitle,
        "from_date": fromDate,
        "to_date": toDate,
        "description": description,
        "location": location,
        "priority": priority,
        "status": status,
        "work_type": workType,
        "stage_name": stageName,
        "attachments": List<dynamic>.from(attachments.map((x) => x)),
    };
}
