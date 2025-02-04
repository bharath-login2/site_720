// To parse this JSON data, do
//
//     final getStagesModel = getStagesModelFromJson(jsonString);

import 'dart:convert';

GetStagesModel getStagesModelFromJson(String str) => GetStagesModel.fromJson(json.decode(str));

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
        data: List<GetStages>.from(json["data"].map((x) => GetStages.fromJson(x))),
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
    String stageName;
    String estDays;
    String createdBy;
    String username;

    GetStages({
        required this.stageName,
        required this.estDays,
        required this.createdBy,
        required this.username,
    });

    factory GetStages.fromJson(Map<String, dynamic> json) => GetStages(
        stageName: json["stage_name"]??"",
        estDays: json["est_days"]??"",
        createdBy: json["created_by"]??"",
        username: json["username"]??"",
    );

    Map<String, dynamic> toJson() => {
        "stage_name": stageName,
        "est_days": estDays,
        "created_by": createdBy,
        "username": username,
    };
}
