// To parse this JSON data, do
//
//     final getStagesModel = getStagesModelFromJson(jsonString);

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
        message: json["message"],
        status: json["status"],
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
  String curingDays;
  String createdBy;
  String phaseId;
  String username;
  String phaseName;
  DateTime startDate;
  DateTime endDate;

  GetStages({
    required this.stageId,
    required this.stageName,
    required this.estDays,
    required this.curingDays,
    required this.createdBy,
    required this.phaseId,
    required this.username,
    required this.phaseName,
    required this.startDate,
    required this.endDate,
  });

  factory GetStages.fromJson(Map<String, dynamic> json) => GetStages(
        stageId: json["stage_id"] ?? "",
        stageName: json["stage_name"] ?? "",
        estDays: json["est_days"] ?? "",
        curingDays: json["curingdays"] ?? "",
        createdBy: json["created_by"] ?? "",
        phaseId: json["phase_id"] ?? "",
        username: json["username"] ?? "",
        phaseName: json["phase_name"] ?? "",
        // startDate: DateTime.parse(json["start_date"]??""),
        // endDate: DateTime.parse(json["end_date"]??""),
        startDate: json["start_date"] != null && json["start_date"] != ""
            ? DateTime.parse(json["start_date"])
            : DateTime(1970, 1, 1),
        endDate: json["end_date"] != null && json["end_date"] != ""
            ? DateTime.parse(json["end_date"])
            : DateTime(1970, 1, 1),
      );

  Map<String, dynamic> toJson() => {
        "stage_id": stageId,
        "stage_name": stageName,
        "est_days": estDays,
        "curing_days": curingDays,
        "created_by": createdBy,
        "phase_id": phaseId,
        "username": username,
        "phase_name": phaseName,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
      };
}
