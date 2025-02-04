// To parse this JSON data, do
//
//     final addWorkModel = addWorkModelFromJson(jsonString);

import 'dart:convert';

AddWorkDetailsModel addWorkDetailsModelFromJson(String str) =>
    AddWorkDetailsModel.fromJson(json.decode(str));

String addWorkDetailsModelToJson(AddWorkDetailsModel data) =>
    json.encode(data.toJson());

class AddWorkDetailsModel {
  List<WorkIssues> data;
  String message;
  bool status;

  AddWorkDetailsModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory AddWorkDetailsModel.fromJson(Map<String, dynamic> json) =>
      AddWorkDetailsModel(
        data: List<WorkIssues>.from(
            json["data"].map((x) => WorkIssues.fromJson(x))),
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
