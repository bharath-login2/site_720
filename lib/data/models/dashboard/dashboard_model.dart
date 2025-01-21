// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) => DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
    Data data;
    String message;
    bool status;

    DashboardModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
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
    ProjectCounts projectCounts;
    List<ComplaintCount> complaintCounts;
    List<WorkissuesCount> workissuesCounts;

    Data({
        required this.username,
        required this.designation,
        required this.projectCounts,
        required this.complaintCounts,
        required this.workissuesCounts,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        username: json["username"],
        designation: json["designation"],
        projectCounts: ProjectCounts.fromJson(json["project_counts"]),
        complaintCounts: List<ComplaintCount>.from(json["complaint_counts"].map((x) => ComplaintCount.fromJson(x))),
        workissuesCounts: List<WorkissuesCount>.from(json["workissues_counts"].map((x) => WorkissuesCount.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "designation": designation,
        "project_counts": projectCounts.toJson(),
        "complaint_counts": List<dynamic>.from(complaintCounts.map((x) => x.toJson())),
        "workissues_counts": List<dynamic>.from(workissuesCounts.map((x) => x.toJson())),
    };
}

class ComplaintCount {
    String statusName;
    String count;

    ComplaintCount({
        required this.statusName,
        required this.count,
    });

    factory ComplaintCount.fromJson(Map<String, dynamic> json) => ComplaintCount(
        statusName: json["status_name"],
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "status_name": statusName,
        "count": count,
    };
}

class ProjectCounts {
    String upcoming;
    String running;
    String completed;

    ProjectCounts({
        required this.upcoming,
        required this.running,
        required this.completed,
    });

    factory ProjectCounts.fromJson(Map<String, dynamic> json) => ProjectCounts(
        upcoming: json["upcoming"],
        running: json["running"],
        completed: json["completed"],
    );

    Map<String, dynamic> toJson() => {
        "upcoming": upcoming,
        "running": running,
        "completed": completed,
    };
}

class WorkissuesCount {
    String workissueName;
    String count;

    WorkissuesCount({
        required this.workissueName,
        required this.count,
    });

    factory WorkissuesCount.fromJson(Map<String, dynamic> json) => WorkissuesCount(
        workissueName: json["workissue_name"],
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "workissue_name": workissueName,
        "count": count,
    };
}
