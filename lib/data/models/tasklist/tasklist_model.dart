// To parse this JSON data, do
//
//     final getTaskList = getTaskListFromJson(jsonString);

import 'dart:convert';

GetTaskList getTaskListFromJson(String str) => GetTaskList.fromJson(json.decode(str));

String getTaskListToJson(GetTaskList data) => json.encode(data.toJson());

class GetTaskList {
    List<Tasks> data;
    String message;
    bool status;

    GetTaskList({
        required this.data,
        required this.message,
        required this.status,
    });

    factory GetTaskList.fromJson(Map<String, dynamic> json) => GetTaskList(
        data: List<Tasks>.from(json["data"].map((x) => Tasks.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class Tasks {
    String id;
    String taskTitle;
    String fromDate;
    String toDate;
    String description;
    String location;
    String priority;
    String status;
    String workType;
    String staffName;
    String stageName;

    Tasks({
        required this.id,
        required this.taskTitle,
        required this.fromDate,
        required this.toDate,
        required this.description,
        required this.location,
        required this.priority,
        required this.status,
        required this.workType,
        required this.staffName,
        required this.stageName,
    });

    factory Tasks.fromJson(Map<String, dynamic> json) => Tasks(
        id: json["id"],
        taskTitle: json["task_title"]??"",
        fromDate: json["from_date"]??"",
        toDate: json["to_date"]??"",
        description: json["description"]??"",
        location: json["location"]??"",
        priority: json["priority"]??"",
        status: json["status"]??"",
        workType: json["work_type"]??"",
        staffName: json["staff_name"]??"",
        stageName: json["stage_name"]??"",
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
        "staff_name": staffName,
        "stage_name": stageName,
    };
}
