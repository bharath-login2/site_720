// To parse this JSON data, do
//
//     final addWorkModel = addWorkModelFromJson(jsonString);

import 'dart:convert';

AddWorkModel addWorkModelFromJson(String str) => AddWorkModel.fromJson(json.decode(str));

String addWorkModelToJson(AddWorkModel data) => json.encode(data.toJson());

class AddWorkModel {
    List<WorkIssues> data;
    String message;
    bool status;

    AddWorkModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory AddWorkModel.fromJson(Map<String, dynamic> json) => AddWorkModel(
        data: List<WorkIssues>.from(json["data"].map((x) => WorkIssues.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class WorkIssues {
    String id;
    String workStatus;

    WorkIssues({
        required this.id,
        required this.workStatus,
    });

    factory WorkIssues.fromJson(Map<String, dynamic> json) => WorkIssues(
        id: json["id"],
        workStatus: json["work_status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "work_status": workStatus,
    };
}
