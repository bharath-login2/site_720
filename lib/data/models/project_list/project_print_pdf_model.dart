// To parse this JSON data, do
//
//     final projectPrintPdfModel = projectPrintPdfModelFromJson(jsonString);

import 'dart:convert';

ProjectPrintPdfModel projectPrintPdfModelFromJson(String str) => ProjectPrintPdfModel.fromJson(json.decode(str));

String projectPrintPdfModelToJson(ProjectPrintPdfModel data) => json.encode(data.toJson());

class ProjectPrintPdfModel {
    bool status;
    String message;
    String pdfUrl;

    ProjectPrintPdfModel({
        required this.status,
        required this.message,
        required this.pdfUrl,
    });

    factory ProjectPrintPdfModel.fromJson(Map<String, dynamic> json) => ProjectPrintPdfModel(
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
