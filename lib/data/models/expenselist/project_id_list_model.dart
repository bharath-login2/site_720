// To parse this JSON data, do
//
//     final getProjectIdList = getProjectIdListFromJson(jsonString);

import 'dart:convert';

GetProjectIdList getProjectIdListFromJson(String str) =>
    GetProjectIdList.fromJson(json.decode(str));

String getProjectIdListToJson(GetProjectIdList data) =>
    json.encode(data.toJson());

class GetProjectIdList {
  List<ProjectIdList> data;
  String message;
  bool status;

  GetProjectIdList({
    required this.data,
    required this.message,
    required this.status,
  });

  factory GetProjectIdList.fromJson(Map<String, dynamic> json) =>
      GetProjectIdList(
        data: List<ProjectIdList>.from(
          (json["data"] ?? []).map(
            (x) => ProjectIdList.fromJson(x),
          ),
        ),
        message: json["message"] ?? "",
        status: json["status"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(
          data.map(
            (x) => x.toJson(),
          ),
        ),
        "message": message,
        "status": status,
      };
}

class ProjectIdList {
  String id;
  String projectName;
  String projectId;

  ProjectIdList({
    required this.id,
    required this.projectName,
    required this.projectId,
  });

  factory ProjectIdList.fromJson(
    Map<String, dynamic> json,
  ) =>
      ProjectIdList(
        id: json["id"]?.toString() ?? "",
        projectName: json["account_head"]?.toString() ?? "",
        projectId: json["project_id"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "account_head": projectName,
        "project_id": projectId,
      };
}
