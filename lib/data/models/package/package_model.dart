// To parse this JSON data, do
//
//     final packageModel = packageModelFromJson(jsonString);

import 'dart:convert';

PackageModel packageModelFromJson(String str) => PackageModel.fromJson(json.decode(str));

String packageModelToJson(PackageModel data) => json.encode(data.toJson());

class PackageModel {
    bool status;
    String message;
    String pdfUrl;

    PackageModel({
        required this.status,
        required this.message,
        required this.pdfUrl,
    });

    factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
        status: json["status"],
        message: json["message"],
        pdfUrl: json["pdf_url"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "pdf_url": pdfUrl,
    };
}
