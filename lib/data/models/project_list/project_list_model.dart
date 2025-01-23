// To parse this JSON data, do
//
//     final projectListModel = projectListModelFromJson(jsonString);

import 'dart:convert';

ProjectListModel projectListModelFromJson(String str) => ProjectListModel.fromJson(json.decode(str));

String projectListModelToJson(ProjectListModel data) => json.encode(data.toJson());

class ProjectListModel {
    Data data;
    String message;
    bool status;

    ProjectListModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory ProjectListModel.fromJson(Map<String, dynamic> json) => ProjectListModel(
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
    String username;
    String designation;
    String totalProjectCount;
    List<ProjectList> projectList;

    Data({
        required this.username,
        required this.designation,
        required this.totalProjectCount,
        required this.projectList,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        username: json["username"],
        designation: json["designation"],
        totalProjectCount: json["total_project_count"],
        projectList: List<ProjectList>.from(json["project_list"].map((x) => ProjectList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "designation": designation,
        "total_project_count": totalProjectCount,
        "project_list": List<dynamic>.from(projectList.map((x) => x.toJson())),
    };
}

class ProjectList {
    String id;
    String projectName;
    String location;
    String clientId;
    String workStatus;
    String startingDate;
    String completionDate;
    String totalAmount;
    bool paymentStatus;

    ProjectList({
        required this.id,
        required this.projectName,
        required this.location,
        required this.clientId,
        required this.workStatus,
        required this.startingDate,
        required this.completionDate,
        required this.totalAmount,
        required this.paymentStatus,
    });

    factory ProjectList.fromJson(Map<String, dynamic> json) => ProjectList(
        id: json["id"],
        projectName: json["project_name"],
        location: json["location"],
        clientId: json["client_id"],
        workStatus: json["work_status"],
        startingDate: json["starting_date"],
        completionDate: json["completion_date"],
        totalAmount: json["total_amount"],
        paymentStatus: json["payment_status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "project_name": projectName,
        "location": location,
        "client_id": clientId,
        "work_status": workStatus,
        "starting_date": startingDate,
        "completion_date": completionDate,
        "total_amount": totalAmount,
        "payment_status": paymentStatus,
    };
}
