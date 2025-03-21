// To parse this JSON data, do
//
//     final versionModel = versionModelFromJson(jsonString);

import 'dart:convert';

VersionModel versionModelFromJson(String str) => VersionModel.fromJson(json.decode(str));

String versionModelToJson(VersionModel data) => json.encode(data.toJson());

class VersionModel {
    String data;
    String message;
    bool status;

    VersionModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory VersionModel.fromJson(Map<String, dynamic> json) => VersionModel(
        data: json["data"],
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": data,
        "message": message,
        "status": status,
    };
}
