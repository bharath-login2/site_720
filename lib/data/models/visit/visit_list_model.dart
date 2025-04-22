// To parse this JSON data, do
//
//     final listVisitModel = listVisitModelFromJson(jsonString);

import 'dart:convert';

ListVisitModel listVisitModelFromJson(String str) => ListVisitModel.fromJson(json.decode(str));

String listVisitModelToJson(ListVisitModel data) => json.encode(data.toJson());

class ListVisitModel {
    Data data;
    String message;
    bool status;

    ListVisitModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory ListVisitModel.fromJson(Map<String, dynamic> json) => ListVisitModel(
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
    List<AvailableStatus> availableStatus;

    Data({
        required this.status,
        required this.message,
        required this.availableStatus,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        message: json["message"],
        availableStatus: List<AvailableStatus>.from(json["available_status"].map((x) => AvailableStatus.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "available_status": List<dynamic>.from(availableStatus.map((x) => x.toJson())),
    };
}

class AvailableStatus {
   String id;
    String taskTitle;
    String projectId;
    DateTime fromDate;
    DateTime toDate;
    String status;
    String visitId;
    String projectName;

    AvailableStatus({
       required this.id,
        required this.taskTitle,
        required this.projectId,
        required this.fromDate,
        required this.toDate,
        required this.status,
        required this.visitId,
        required this.projectName,
    });

    factory AvailableStatus.fromJson(Map<String, dynamic> json) => AvailableStatus(
        id: json["id"]??"",
        taskTitle: json["task_title"]??"",
        projectId: json["project_id"]??"",
        fromDate: DateTime.parse(json["from_date"]??""),
        toDate: DateTime.parse(json["to_date"]??""),
        status: json["status"]??"",
        visitId: json["visit_id"]??"",
        projectName: json["project_name"]??"",
    );

    Map<String, dynamic> toJson() => {
         "id": id,
        "task_title": taskTitle,
        "project_id": projectId,
        "from_date": "${fromDate.year.toString().padLeft(4, '0')}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}",
        "to_date": "${toDate.year.toString().padLeft(4, '0')}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}",
        "status": status,
        "visit_id": visitId,
        "project_name": projectName,
    };
}
