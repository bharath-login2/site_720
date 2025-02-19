// To parse this JSON data, do
//
//     final siteDrawingsList = siteDrawingsListFromJson(jsonString);

import 'dart:convert';

SiteDrawingsList siteDrawingsListFromJson(String str) => SiteDrawingsList.fromJson(json.decode(str));

String siteDrawingsListToJson(SiteDrawingsList data) => json.encode(data.toJson());

class SiteDrawingsList {
    List<Drawings> data;
    String message;
    bool status;

    SiteDrawingsList({
        required this.data,
        required this.message,
        required this.status,
    });

    factory SiteDrawingsList.fromJson(Map<String, dynamic> json) => SiteDrawingsList(
        data: List<Drawings>.from(json["data"].map((x) => Drawings.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class Drawings {
    String id;
    String fileName;
    String remarks;

    Drawings({
        required this.id,
        required this.fileName,
        required this.remarks,
    });

    factory Drawings.fromJson(Map<String, dynamic> json) => Drawings(
        id: json["id"]??"",
        fileName: json["file_name"]??"",
        remarks: json["remarks"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "file_name": fileName,
        "remarks": remarks,
    };
}
