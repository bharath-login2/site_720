// To parse this JSON data, do
//
//     final satgeProModel = satgeProModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SatgeProModel satgeProModelFromJson(String str) =>
    SatgeProModel.fromJson(json.decode(str));

String satgeProModelToJson(SatgeProModel data) => json.encode(data.toJson());

class SatgeProModel {
  List<StageListPro> data;
  String message;
  bool status;

  SatgeProModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory SatgeProModel.fromJson(Map<String, dynamic> json) => SatgeProModel(
        data: List<StageListPro>.from(
            json["data"].map((x) => StageListPro.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class StageListPro {
  String stageId;
  String stageName;

  StageListPro({
    required this.stageId,
    required this.stageName,
  });

  factory StageListPro.fromJson(Map<String, dynamic> json) => StageListPro(
        stageId: json["stage_id"],
        stageName: json["stage_name"],
      );

  Map<String, dynamic> toJson() => {
        "stage_id": stageId,
        "stage_name": stageName,
      };
}
