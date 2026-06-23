import 'dart:convert';

GetStagesModel getStagesModelFromJson(String str) =>
    GetStagesModel.fromJson(json.decode(str));

String getStagesModelToJson(GetStagesModel data) => json.encode(data.toJson());

class GetStagesModel {
  List<GetStages> data;
  String message;
  bool status;

  GetStagesModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory GetStagesModel.fromJson(Map<String, dynamic> json) => GetStagesModel(
        data: List<GetStages>.from(
            json["data"].map((x) => GetStages.fromJson(x))),
        message: json["message"] ?? "",
        status: json["status"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class GetStages {
  String stageId;
  String stageName;
  String estDays;
  String createdBy;
  String username;
  String curingDays;
  DateTime startDate;
  DateTime endDate;
  String isLocked;
  String stageStatus;
  String projectId;
  String clientId;

  GetStages({
    required this.stageId,
    required this.stageName,
    required this.estDays,
    required this.createdBy,
    required this.username,
    required this.curingDays,
    required this.startDate,
    required this.endDate,
    required this.isLocked,
    required this.stageStatus,
    required this.projectId,
    required this.clientId,
  });

  factory GetStages.fromJson(Map<String, dynamic> json) => GetStages(
        stageId: json["stage_id"] ?? "",
        stageName: json["stage_name"] ?? "",
        estDays: json["est_days"] ?? "",
        createdBy: json["created_by"] ?? "",
        username: json["username"] ?? "",
        curingDays: json["curing_days"] ?? "",
        startDate: json["start_date"] != null && json["start_date"] != ""
            ? DateTime.parse(json["start_date"])
            : DateTime(1970, 1, 1),
        endDate: json["end_date"] != null && json["end_date"] != ""
            ? DateTime.parse(json["end_date"])
            : DateTime(1970, 1, 1),
        isLocked: json["is_locked"] ?? "",
        stageStatus: json["stage_status"] ?? "",
        projectId: json["project_id"] ?? "",
        clientId: json["client_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "stage_id": stageId,
        "stage_name": stageName,
        "est_days": estDays,
        "created_by": createdBy,
        "username": username,
        "curing_days": curingDays,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "is_locked": isLocked,
        "stage_status": stageStatus,
        "project_id": projectId,
        "client_id": clientId,
      };
}
