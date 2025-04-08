// To parse this JSON data, do
//
//     final wokIssueListModel = wokIssueListModelFromJson(jsonString);

import 'dart:convert';

WorkIssueListModel workIssueListModelFromJson(String str) =>
    WorkIssueListModel.fromJson(json.decode(str));

String wokIssueListModelToJson(WorkIssueListModel data) =>
    json.encode(data.toJson());

class WorkIssueListModel {
  List<Issues> data;
  String message;
  bool status;

  WorkIssueListModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory WorkIssueListModel.fromJson(Map<String, dynamic> json) =>
      WorkIssueListModel(
        data: List<Issues>.from(json["data"].map((x) => Issues.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class Issues {
  String id;
  String clientId;
  String isWorking;
  String workDate;
  String description;
  String workDay;
  String workMonth;
  String workYear;
  String laboursNo;
  String workStatusId;
  String workStatus;
  String projectName;

  Issues({
    required this.id,
    required this.clientId,
    required this.isWorking,
    required this.workDate,
    required this.description,
    required this.workDay,
    required this.workMonth,
    required this.workYear,
    required this.laboursNo,
    required this.workStatusId,
    required this.workStatus,
    required this.projectName,
  });

  factory Issues.fromJson(Map<String, dynamic> json) => Issues(
        id: json["id"],
        clientId: json["client_id"],
        isWorking: json["is_working"],
        workDate: json["work_date"],
        description: json["description"],
        workDay: json["work_day"],
        workMonth: json["work_month"],
        workYear: json["work_year"],
        laboursNo: json["labours_no"],
        workStatusId: json["work_status_id"],
        workStatus: json["work_status"],
        projectName: json["project_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "is_working": isWorking,
        "work_date": workDate,
        "description": description,
        "work_day": workDay,
        "work_month": workMonth,
        "work_year": workYear,
        "labours_no": laboursNo,
        "work_status_id": workStatusId,
        "work_status": workStatus,
        "project_name": projectName,
      };
}
